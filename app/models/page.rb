class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  DURATION = "years"
  MININOTE = 100 # keep first this many characters plus enough for full words in index headers
  LIMIT = 10

  UNREAD = "unread"
  FAVORITE = "favorite"
  REREAD = "reread"

  SIZES = ["short", "long", "epic"]
  STATES = [UNREAD, FAVORITE, REREAD]
  SHORT_WC = 1000
  LONG_WC = 10000
  EPIC_WC = 80000

  BASE_URL_PLACEHOLDER = "Base URL: use * as replacement placeholder"
  URL_SUBSTITUTIONS_PLACEHOLDER = "URL substitutions, space separated replacements or inclusive integer range n-m"
  URLS_PLACEHOLDER = "Alternatively: full URLs for parts, one per line"


  has_and_belongs_to_many :genres, :uniq => true
  has_and_belongs_to_many :authors, :uniq => true
  belongs_to :parent, :class_name => "Page"
  belongs_to :ultimate_parent, :class_name => "Page"

  validates_presence_of :title, :message => "can't be blank or 'Title'"
  validates_format_of :url, :with => URI.regexp, :allow_blank => true

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls
    
  default_scope :order => 'read_after ASC'
  named_scope :no_children, :conditions => {:parent_id => nil}
  named_scope :short, :conditions => {:size => "short"}
  named_scope :long, :conditions => {:size => "long"}
  named_scope :epic, :conditions => {:size => "epic"} 
  named_scope :unread, :conditions => {:last_read => nil }
  named_scope :reread, :conditions => 'last_read is not null'
  named_scope :favorite, :conditions => {:favorite => true }  
  named_scope :limited, :limit => LIMIT, :select => 'DISTINCT *'
  named_scope :include_root, :include => :ultimate_parent

  named_scope :search_title, lambda {|string| 
    {:conditions => ["title LIKE ?", "%" + string + "%"]}
  }
  named_scope :search_notes, lambda {|string| 
    {:conditions => ["notes LIKE ?", "%" + string + "%"]}
  }
  named_scope :search_url, lambda {|string| 
    {:conditions => ["url LIKE ?", "%" + string + "%"]}
  }

  def self.find_random
    count = self.count
    return nil if count == 0
    offset = rand(count)
    page = self.find(:first, :offset => offset)
    page.ultimate_parent if page
  end

  def self.filter(hash={})
    if hash.has_key?("state")
      case hash["state"]
        when "unread"
          state = Page.unread.include_root.map(&:ultimate_parent)
        when "reread"  
          state = Page.reread.no_children
        when "favorite"
          state = Page.favorite.include_root.map(&:ultimate_parent)
      end
    else
      state = Page.no_children
    end
    if hash.has_key?("size")
      case hash["size"]
        when "short"
          size =  Page.short.no_children
        when "long"
          size =  Page.long.no_children
        when "epic"
          size =  Page.epic.no_children
      end
    else
      size = Page.no_children
    end
    title = hash.has_key?("title") ? Page.search_title(hash["title"]).include_root.map(&:ultimate_parent) : Page.no_children
    notes = hash.has_key?("notes") ? Page.search_notes(hash["notes"]).include_root.map(&:ultimate_parent) : Page.no_children
    url = hash.has_key?("url") ? Page.search_url(hash["url"]).include_root.map(&:ultimate_parent) : Page.no_children
    genre =  hash.has_key?("genre") ? Genre.find_by_name(hash["genre"]).pages.include_root.map(&:ultimate_parent) : Page.no_children
    author =  hash.has_key?("author") ? Author.find_by_name(hash["author"]).pages.no_children : Page.no_children
    (state & size & title & notes & url & genre & author).compact.uniq[0...LIMIT]
  end

  def to_param
    "#{self.id}-#{self.clean_title}"
  end

  def clean_title
    clean = self.title.gsub('/', '')
    CGI::escape(clean).gsub('+', ' ').gsub('.', ' ')
  end

  def before_validation
    self.url = self.url == "Url" ? nil : self.url.try(:strip)
    self.title = nil if self.title == "Title"
    self.notes = nil if self.notes == "Notes"
    self.base_url = nil if self.base_url == BASE_URL_PLACEHOLDER
    self.url_substitutions = nil if self.url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    self.urls = nil if self.urls == URLS_PLACEHOLDER
    self.read_after = Time.now if self.read_after.blank?
  end

  def after_create
    FileUtils.mkdir_p(Rails.public_path +  self.mypath)
    self.raw_html = ""
    if self.url
      fetch
    elsif self.base_url
      self.create_from_base
    elsif self.urls
      self.parts_from_urls(self.urls)
    end
    self.update_ultimate_parent
  end
  
  before_update

  def update_ultimate_parent
    self.update_attribute(:ultimate_parent_id, self.find_ultimate_parent.id) 
  end

  def wordcount
    wordcount = self.remove_html.scan(/(\w|-)+/).size
  end

  def set_wordcount
    self.size = nil
    self.size = "short" if wordcount < SHORT_WC
    self.size = "long" if wordcount > LONG_WC
    self.size = "epic" if wordcount > EPIC_WC
    self.save
  end

  def pasted=(html)
    self.raw_html = html
    self.build_me
  end

  def fetch(url=self.url)
    return if url.blank?
    self.update_attribute(:url, url) if url != self.url
    agent = WWW::Mechanize.new
    auth = MyWebsites.getpwd(url)
    agent.auth(auth[:username], auth[:password]) if auth
    begin
      page = agent.get(MyWebsites.geturl(url))
      if url.match(/livejournal/) && page.forms.first.try(:button).try(:name) == "adult_check"
         form = page.forms.first
         page = agent.submit(form, form.buttons.first)
      end
      self.raw_html = page.body
      self.build_me
    rescue WWW::Mechanize::ResponseCodeError
      self.errors.add(:base, "error retrieving content")
    rescue SocketError
      self.errors.add(:base, "couldn't resolve host name")
    end
  end

  def build_me(reclean=false)
    html = reclean ? self.clean_html : self.raw_html
    body = Scrub.regularize_body(html)
    body = MyWebsites.getnode(self.url, body) unless reclean
    if body
      html = Scrub.to_xhtml(body)
      self.clean_html = Scrub.sanitize_html(html)
    else
      self.clean_html = ""
    end
    self.set_wordcount
  end

  def create_from_base
    count = 1
    match = self.url_substitutions.match("-")
    if match
      array = match.pre_match.to_i .. match.post_match.to_i
    else
      array = self.url_substitutions.split
    end
    array.each do |sub|
      title = "Part " + count.to_s
      create_child(self.base_url.gsub(/\*/, sub.to_s), count, title)
      count = count.next
    end
    self.set_wordcount
  end

  def parts_from_urls(url_title_list, refetch=false)
    old_part_ids = self.parts.map(&:id)
    new_part_ids = []

    lines = url_title_list.split(/[\r\n]/).select {|l| l.chomp} - [""]

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
      url = title = position = nil
      url = part.sub(/#.*/, "")
      title = part.sub(/.*#/, "") if part.match("#")
      position = parts.index(part) + 1
      title = "Part " + position.to_s unless title
      page = Page.find_by_url(url) unless url.blank?
      page = Page.find_by_title_and_parent_id(title, parent.id) unless page
      if page.blank?
        page = Page.create(:url=>url, :title=>title, :parent_id=>parent.id, :position => position)
        parent.update_attribute(:read_after, Time.now) if parent.read_after > Time.now
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
        part.update_attribute(:read_after, Time.now) if part.read_after > Time.now
        parent.update_attribute(:read_after, Time.now) if parent.read_after > Time.now
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
    parent.set_wordcount
  end

  def build_html_from_parts
    html = ""
    self.parts.each do |part|
      level = part.parent.parent ? "h2" : "h1"
      html << "\n\n<#{level}>#{part.title}</#{level}>\n"
      if part.parts.blank?
        html << part.clean_html
      else
        html << part.build_html_from_parts
      end
    end
    html
  end

  def create_child(url, position, title)
    Page.create(:title => title, :url => url, :position => position, :parent_id => self.id)
  end

  def parts
    Page.find(:all, :order => :position, :conditions => ["parent_id = ?", id])
  end
  
  def find_ultimate_parent
    return self unless self.parent
    self.parent.find_ultimate_parent
  end

  def url_list
    partregexp = /\APart \d+\Z/
    list = []
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
    return "ambiguous" if pages.size > 1
    parent = nil
    new = false
    if pages.size == 0
      parent = Page.create(:title => title, :last_read => self.last_read, :read_after => self.read_after)
      new = true
    else
      parent = pages.first
      return parent.raw_html unless parent.raw_html.blank?
    end
    count = parent.parts.size + 1
    self.update_attributes(:parent_id => parent.id, :position => count)
    if new
      parent.genres << self.genres
      parent.authors << self.authors
      parent.update_attribute(:last_read, self.last_read)
      parent.update_attribute(:favorite, self.favorite)
    end
    parent.set_wordcount
    self.update_ultimate_parent
    return parent
  end

  def make_later
    was = self.read_after || Time.now
    self.update_attribute(:read_after, was + 3.months)
    return Page.no_children.first
  end

  def make_first
    earliest = Page.no_children.first.read_after
    self.update_attribute(:read_after, earliest - 1.day)
    if self.parent
      parent = self.parent
      parent.update_attribute(:read_after, earliest - 1.day) if parent
      grandparent = parent.parent
      grandparent.update_attribute(:read_after, earliest - 1.day) if grandparent
    end
    return self
  end

  def set_read_after(string)
    now = Time.now
    after = now + string.to_i.send(DURATION)
    self.update_attributes(:read_after => after, :last_read => now)
    string == "1" ? self.update_attribute(:favorite, true) : self.update_attribute(:favorite, false)
    self.parts.each {|p| p.update_attribute(:last_read, now)}
    return self.read_after
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
  
  def tag_names
    names = self.authors.map(&:name) + self.genres.map(&:name) + [self.size]
    names = names + [FAVORITE] if self.favorite
    names = names + [(self.last_read ? self.last_read.to_date : UNREAD)]
    names.compact
  end
  
  def tag_string
    mine = self.tag_names
    if self.parent
      mine = mine - self.parent.tag_names
    end
    mine.join(", ")
  end
  
  def clean_html=(content)
    File.open(self.clean_html_file, 'w') { |f| f.write(content) }
  end

  def clean_html
    if parts.blank?
      begin
        File.open(self.clean_html_file, 'r') { |f| f.read }
      rescue Errno::ENOENT
        ""
      end
    else
      self.build_html_from_parts
    end
  end

  def clean_html_file
    Rails.public_path +  self.mypath + "original.html"
  end

  def raw_html=(content)
    File.open(self.raw_file_name, 'w') { |f| f.write(content) }
  end

  def raw_html
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
      when "cucumber"; "/test/"
      when "development"; "/development/"
      when "production"; "/files/"
    end
    env + (self.id/MODULO).to_s + "/" + self.id.to_s + "/"
  end

  def nodes
    html = self.clean_html + "<div></div>"
    array = []
    all = Nokogiri::HTML(html).xpath('//body').children
    all.each do |node|
      unless (node.is_a?(Nokogiri::XML::Text) && node.to_html.blank?)
        array << node.to_xhtml 
      end
    end
    array
  end

  def remove_surrounding_div!
    self.clean_html = Nokogiri::HTML(self.clean_html).xpath('//body').children.first.children.to_xhtml
  end

  def remove_nodes(ids)
    node_array = self.nodes.to_a
    all = node_array.size - 1
    first = ids[0].to_i
    if ids[1]
      first = first + 1
      last = ids[1].to_i - 1
      if first == last
        self.clean_html=node_array[first].to_s
      else
        self.clean_html=node_array[first..last].to_s
      end
    else
      if first > all/2
        self.clean_html=node_array[0..first-1].to_s
      else
        self.clean_html=node_array[first + 1..all].to_s
      end
    end
    self.set_wordcount
  end

  def remove_html
    self.build_me(true) if self.needs_recleaning?
    Scrub.html_to_text(self.clean_html)
  end
  
  def needs_recleaning?
    return true unless File.exists?(self.clean_html_file)
    File.mtime(self.clean_html_file) < File.mtime(Rails.root + "lib/scrub.rb")
  end
  
  def short_notes
    return self.notes if self.notes.blank?
    return self.notes if self.notes.size < MININOTE
    snip_idx = self.notes.index(/\s/, MININOTE)
    return self.notes unless snip_idx
    self.notes[0, snip_idx] + "..."
  end


end
