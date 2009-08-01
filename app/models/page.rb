class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  TITLE_PLACEHOLDER = "Enter a Title for the new page"
  URL_PLACEHOLDER = "Enter a URL for a new page"
  BASE_URL_PLACEHOLDER = "Base URL: use * as replacement placeholder"
  URL_SUBSTITUTIONS_PLACEHOLDER = "URL substitutions, space separated replacements for base URL"
  URLS_PLACEHOLDER = "Alternatively: full URLs for parts, one per line"
  DURATION = "years"

  has_and_belongs_to_many :genres, :uniq => true
  has_and_belongs_to_many :authors, :uniq => true
  has_and_belongs_to_many :states, :uniq => true
  belongs_to :parent, :class_name => "Page"
  default_scope :order => 'read_after ASC'
  named_scope :parents, :conditions => {:parent_id => nil}
  validates_presence_of :title
  validates_format_of :url, :with => URI.regexp, :allow_blank => true

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls

  def self.search(string)
    pages = Page.find(:all, :conditions => ["title LIKE ?", "%" + string + "%"])
    if pages.blank?
      pages = Page.find(:all, :conditions => ["notes LIKE ?", "%" + string + "%"])
    end
    parents = []
    pages.each do |page|
      parents << (page.parent ? page.parent : page)
    end
    parents.compact.uniq
  end

  def self.filter(state, genre, author)
    by_state = state.is_a?(State) ? state.pages.parents : Page.parents
    by_genre = genre.is_a?(Genre) ? genre.pages.parents : Page.parents
    by_author = author.is_a?(Author) ? author.pages.parents : Page.parents
    by_author & by_genre & by_state
  end

  def before_validation
    self.url = nil if self.url == URL_PLACEHOLDER
    self.title = nil if self.title == TITLE_PLACEHOLDER
    self.base_url = nil if self.base_url == BASE_URL_PLACEHOLDER
    self.url_substitutions = nil if self.url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    self.urls = nil if self.urls == URLS_PLACEHOLDER
    self.read_after = Time.now if self.read_after.blank?
  end

  def after_create
    FileUtils.mkdir_p(Rails.public_path +  self.mypath)
    if self.url
      fetch
    elsif self.base_url
      self.create_from_base
    elsif self.urls
      self.parts_from_urls(self.urls)
    else
      self.build_html_from_parts
    end
    self.states << State.find_or_create_by_name(State::UNREAD) unless self.last_read
    self.set_wordcount
  end

  def wordcount
    wordcount = self.remove_html.scan(/(\w|-)+/).size
  end

  def set_wordcount
    short = State.find_or_create_by_name(State::SHORT)
    long = State.find_or_create_by_name(State::LONG)
    epic = State.find_or_create_by_name(State::EPIC)
    self.states.delete(short)
    self.states.delete(long)
    self.states.delete(epic)
    if self.wordcount < State::SHORT_WC
      self.states << short
    elsif self.wordcount > State::EPIC_WC
      self.states << epic
    elsif self.wordcount > State::LONG_WC
      self.states << long
    end
  end

  def pasted=(html)
    self.raw_content = html
    self.build_me
  end

  def fetch(url=self.url)
    return if url.blank?
    self.update_attribute(:url, url) if url != self.url
    pwd = Curl::External.getpwd(url)
    url = Curl::External.geturl(url)
    begin
      Curl::Easy.download(url, self.raw_file_name) {|c| c.userpwd = pwd}
    rescue Curl::Err::HostResolutionError # ignore
      self.raw_content = "Couldn't resolve host name"
      url = "failed"
    rescue Curl::Err::ConnectionFailedError #ignore
      self.raw_content = "Server down"
      url = "failed"
    rescue Curl::Err::GotNothingError # retry
      begin
        Curl::Easy.download(url, self.raw_file_name) {|c| c.userpwd = pwd}
      rescue Curl::Err::GotNothingError
        self.raw_content = "Timed out"
        url = "failed"
      rescue Curl::Err::ConnectionFailedError #ignore
        self.raw_content = "Server down"
        url = "failed"
      end
    end
    self.build_me
  end

  def build_me(input="latin1")
    File.unlink(self.mobile_file_name) rescue Errno::ENOENT
    input = "utf8" if self.raw_content.match(/charset ?= ?"?utf-8/i)
    self.original_html = self.pre_process(self.raw_file_name, input)
    self.original_html = Curl::External.getnode(url, self.original_html)
    self.set_wordcount
  end

  def pre_process(filename, input)
    html = `tidy -config #{Rails.root.to_s + "/config/tidy.conf"} --input-encoding #{input} #{filename}`
    html = html.gsub(/&nbsp;/, " ")
    html = html.gsub(/<noscript.*?>.*?<\/noscript>/i, "")
    html = Sanitize.clean(html, :elements => [ 'a', 'big', 'blockquote', 'br', 'center', 'div', 'dt', 'em', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'hr', 'img', 'li', 'p', 'small', 'strike', 'strong', 'sub', 'sup', 'u'], :attributes => { 'a' => ['href'], 'div' => ['id', 'class'], 'img' => ['align', 'alt', 'height', 'src', 'title', 'width'] })
    html = html.gsub(/\n/, "")
    html = html.gsub(/ +/, ' ')
    html = html.gsub(/<br \/><br \/>/, "<p>")
    html = html.gsub(/<a><\/a>/, "")
    html = html.gsub(/<p> ?<\/p>/, "")
  end

  def create_from_base
    count = 1
    self.url_substitutions.split.each do |sub|
      title = "Part " + count.to_s
      create_child(self.base_url.gsub(/\*/, sub), count, title)
      count = count.next
    end
    self.build_html_from_parts
  end

  def parts_from_urls(url_title_list, refetch=false)
    old_part_ids = self.parts.map(&:id)
    new_part_ids = []

    lines = url_title_list.split(/[\r\n]/).select {|l| l.chomp} - [""]

    my_title = lines.first.sub("#", "") if lines.first.match "^#"
    self.update_attribute(:title, my_title) unless my_title.blank?

    parts_with_subparts = lines.select {|l| l.match("^##") && !l.match("###")}

    if parts_with_subparts.blank?
      parts = lines.select {|l| !l.match("^#")}
      subparts = []
    else
      parts = lines.select {|l| l.match("##") && !l.match("###")}
      subparts = lines.select {|l| l.match("###") || !l.match("#")}
    end

    if parts.include?(self.url)
      parent = Page.create(:title => self.title)
    else
      parent = self
    end

    parts.each do |part|
      url = part.sub(/#.*/, "")
      title = part.sub(/.*#/, "") if part.match("#")
      position = parts.index(part) + 1
      title = "Part " + position.to_s unless title
      page = Page.find_by_url(url) unless url.blank?
      page = Page.find_by_title_and_parent_id(title, parent.id) unless page
      if page.blank?
        page = Page.create(:url=>url, :title=>title, :parent_id=>parent.id, :position => position)
      else
        if page.url == url
	        page.fetch if refetch
        else
          page.update_attribute(:url, url)
	        page.fetch
	      end
        page.update_attribute(:position, position)
        page.update_attribute(:title, title)
        page.update_attribute(:parent_id, parent.id)
      end
      new_part_ids << page.id
    end

    subparts.each do |subpart|
      url = title = position = nil
      part_string = (lines[0..lines.index(subpart)] & parts).last
      part_title = part_string.split("#").last
      part = Page.find_by_title_and_parent_id(part_title, parent.id)
      url = subpart.sub(/#.*/, "")
      title = subpart.sub(/.*#/, "") if subpart.match("#")
      position = lines.index(subpart) - lines.index(part_string)
      title = "Part " + position.to_s unless title
      page = Page.find_by_url(url)
      if page.blank?
        page = Page.create(:url=>url, :title=>title, :parent_id=>part.id, :position => position)
      else
        if page.url == url
	  page.fetch if refetch
	else
          page.update_attribute(:url, url)
	  page.fetch
	end
	page.update_attribute(:parent_id, part.id)
	page.update_attribute(:title, title)
        page.update_attribute(:position, position)
      end
    end

    remove = old_part_ids - new_part_ids
    remove.each do |old_part_id|
      old_part = Page.find(old_part_id)
      old_part.destroy if old_part.parent == parent
    end
    added = new_part_ids - old_part_ids
    unread = State.find_or_create_by_name(State::UNREAD)
    if !added.blank?
      added.each do |id|
        parent.states << unread if Page.find(id).states.include?(unread)
      end
      if parent.read_after > Time.now
        parent.update_attribute(:read_after, Time.now)
      end
    end
    parent.build_html_from_parts
  end

  def build_html_from_parts
    File.unlink(self.mobile_file_name) rescue Errno::ENOENT
    File.open(self.original_file, 'w') do |file|
      self.parts.each do |part|
        unless part.parts.blank?
          File.unlink(part.mobile_file_name) rescue Errno::ENOENT
	  part.build_html_from_parts
	end
        level = part.parent.parent ? "h2" : "h1"
        file << "\n\n<#{level}>#{part.title}</#{level}>\n"
        file << part.original_html
      end
    end
    self.set_wordcount
  end

  def create_child(url, position, title)
    Page.create(:title => title, :url => url, :position => position, :parent_id => self.id)
  end

  def parts
    Page.find(:all, :order => :position, :conditions => ["parent_id = ?", id])
  end

  def url_list
    partregexp = /\APart \d+\Z/
    list = []
    list << "#" + self.title
    self.parts.each do |part|
      if part.parts.blank?
        line = part.url
        unless part.title.match(partregexp)
          line = line + "##" + part.title
        end
        list << line
      else
        list << "##" + part.title
        part.parts.each do |subpart|
          line = subpart.url
          unless subpart.title.match(partregexp)
            line = line + "###" + subpart.title
          end
          list << line
        end
      end
    end
    list.join("\n")
  end

  def add_parent(title)
    pages=Page.find(:all, :conditions => ["title LIKE ?", "%" + title + "%"])
    return false if pages.size > 1
    parent = nil
    if pages.size == 0
      parent = Page.create(:title => title, :last_read => self.last_read, :read_after => self.read_after)
    else
      parent = pages.first
      return false if parent.parts.blank?
    end
    count = parent.parts.size + 1
    self.update_attributes(:parent_id => parent.id, :position => count)
    parent.genres << self.genres
    parent.authors << self.authors
    parent.build_html_from_parts
    return parent
  end

  def next
    was = self.read_after || Time.now
    self.update_attribute(:read_after, was + 3.months)
    return Page.parents.first
  end

  def first
    earliest = Page.first.read_after
    self.update_attribute(:read_after, earliest - 1.day)
    return self
  end

  def set_read_after(string)
    now = Time.now
    after = now + string.to_i.send(DURATION)
    self.update_attributes(:read_after => after, :last_read => now)
    favorite = State.find_or_create_by_name(State::FAVORITE)
    if string == "1"
      self.states << favorite
    else
      self.states.delete(favorite)
    end
    self.parts.each {|p| p.states.delete(favorite)}
    unread = State.find_or_create_by_name(State::UNREAD)
    self.states.delete(unread)
    self.parts.each {|p| p.states.delete(unread)}
    return self.read_after
  end

  def clean_title
    CGI::escape(self.title).gsub('+', '%20').gsub('.', '%46') + ".txt"
  end

  def state_string
    self.states.map(&:name).join(", ")
  end

  def author_string
    self.authors.map(&:name).join(", ")
  end

  def add_author_string=(string)
    return if string.blank?
    string.split(",").each do |author|
      new = Author.find_or_create_by_name(author.squish)
      self.authors << new
    end
    self.authors
  end

  def genre_string
    self.genres.map(&:name).join(", ")
  end

  def add_genre_string=(string)
    return if string.blank?
    string.split(",").each do |genre|
      new = Genre.find_or_create_by_name(genre.squish)
      self.genres << new
    end
    self.genres
  end

  def original_html=(content)
    File.unlink(self.mobile_file_name) rescue Errno::ENOENT
    File.open(self.original_file, 'w') { |f| f.write(content) }
    if self.parent
      if self.parent.parent
        File.unlink(self.parent.parent.mobile_file_name) rescue Errno::ENOENT
        self.parent.parent.build_html_from_parts
      else
        File.unlink(self.parent.mobile_file_name) rescue Errno::ENOENT
        self.parent.build_html_from_parts
      end
    else
      self.set_wordcount
    end
  end

  def original_html
    begin
      File.open(self.original_file, 'r') { |f| f.read }
    rescue Errno::ENOENT
      ""
    end
  end

  def original_file
    Rails.public_path +  self.mypath + "original.html"
  end

  def mobile_url
    self.mypath + self.clean_title
  end

  def mobile_content=(content)
    File.open(self.mobile_file_name, 'w') { |f| f.write(content) }
  end

  def mobile_file
    unless File.exists?(self.mobile_file_name)
      self.mobile_content=self.remove_html
    end
    self.mobile_file_name
  end

  def mobile_file_name
    Rails.public_path +  self.mypath + self.clean_title
  end

  def raw_content=(content)
    File.open(self.raw_file_name, 'w') { |f| f.write(content) }
  end

  def raw_content
    begin
      File.open(self.raw_file_name, 'r') { |f| f.read }
    rescue Errno::ENOENT
      ""
    end
  end

  def raw_file_name
    Rails.public_path + self.mypath + "raw.html"
  end

  def mypath
    env = case Rails.env
      when "test"; "/test/"
      when "development"; "/development/"
      when "production"; "/files/"
    end
    env + (self.id/MODULO).to_s + "/" + self.id.to_s + "/"
  end

  def nodes
    return if self.original_html.blank?
    Nokogiri::HTML(self.original_html).xpath('//body').first.children
  end

  def remove_nodes(ids)
    node_array = self.nodes.to_a
    all = node_array.size - 1
    first = ids[0].to_i
    if ids[1]
      first = first + 1
      last = ids[1].to_i - 1
      if first == last
        self.original_html=node_array[first]
      else
        self.original_html=node_array[first..last]
      end
    else
      if first > all/2
        self.original_html=node_array[0..first-1]
      else
        self.original_html=node_array[first + 1..all]
      end
    end
    self.set_wordcount
  end

  def remove_html
    text = self.original_html
    text = text.gsub(/<a .*?>(.*?)<\/a>/m) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<\/?big>/, "\*")
    text = text.gsub(/<\/?blockquote>/, "")
    text = text.gsub(/<\/?br>/, "\n")
    text = text.gsub(/<\/?center>/, "")
    text = text.gsub(/<\/?div.*?>/, "\n")
    text = text.gsub(/<dt>/, "")
    text = text.gsub(/<\/dt>/, ": ")
    text = text.gsub(/<\/?em.*?>/, "_")
    text = text.gsub(/<h1>(.*?)<\/h1>/) {|s| "\# #{$1} \#" unless $1.blank?}
    text = text.gsub(/<h2>(.*?)<\/h2>/) {|s| "\#\# #{$1} \#\#" unless $1.blank?}
    text = text.gsub(/<\/?h\d.*?>/, "\*")
    text = text.gsub(/<hr>/, "______________________________")
    text = text.gsub(/<img.*?alt="(.*?)".*?>/) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<img.*?>/, "")
    text = text.gsub(/<li>/, "* ")
    text = text.gsub(/<\/?li>/, "")
    text = text.gsub(/<\/?p>/, "\n")
    text = text.gsub(/<small>/, '(')
    text = text.gsub(/<\/small>/, ')')
    text = text.gsub(/<\/?strike>/, "==")
    text = text.gsub(/<\/?strong.*?>/, "\*")
    text = text.gsub(/<sup>/, "^")
    text = text.gsub(/<\/sup>/, "")
    text = text.gsub(/<sub>/, "(")
    text = text.gsub(/<\/sub>/, ")")
    text = text.gsub(/<\/?u>/, "_")
    text = text.gsub(/_([ ,.?-]+)_/) {|s| $1}
    text = text.gsub(/\*([ ,.?-]+)\*/) {|s| $1}
    text = text.gsub(/&[lr]squo;/, "'")
    text = text.gsub(/&[lr]dquo;/, '"')
    text = text.gsub(/&amp;/, "&")
    text = text.gsub(/&hellip;/, "...")
    text = text.gsub(/&ccedil;/, "c")
    text = text.gsub(/&ordm;/, "o")
    text = text.gsub(/&iuml;/, "i")
    text = text.gsub(/&[mn]dash;/, "--")
    text = text.gsub(/&lt;/, "<")
    text = text.gsub(/&gt;/, ">")
    text.gsub(/ +/, ' ').gsub(/\n+ */, "\n\n").gsub(/\n\n\n\n+/, "\n\n").strip
  end

end
