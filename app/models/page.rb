# encoding=utf-8

class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory

  def mypath
    env = case Rails.env
      when "test"; "/test/"
      when "development"; "/development/"
      when "production"; "/files/"
    end
    env + (self.id/MODULO).to_s + "/" + self.id.to_s + "/"
  end

  DURATION = "years"
  MININOTE = 75 # keep first this many characters plus enough for full words
  LIMIT = 15 # number of pages to show in index

  UNREAD = "unread"
  FAVORITE = "favorite"
  GOOD = "good"

  SIZES = ["short", "medium", "long", "any"]

  SHORT_WC =   7500
  MED_WC   =  30000

  def set_wordcount(recount=true)
    if self.parts.size > 0
      self.parts.each {|part| part.set_wordcount } if recount
      self.wordcount = self.parts.sum(:wordcount)
    elsif recount
      count = 0
      body = Nokogiri::HTML(self.clean_html).xpath('//body').first
      body.traverse { |node|
        if node.is_a? Nokogiri::XML::Text
          words = node.inner_text.gsub(/--/, "—").gsub(/(['’‘-])+/, "")
          count +=  words.scan(/[a-zA-Z0-9À-ÿ_]+/).size
        end
      } if body
      self.wordcount = count
    end
    self.size = "short"
    if self.wordcount
      self.size = "medium" if wordcount > SHORT_WC
      self.size = "long" if wordcount > MED_WC
    end
    self.save
  end

  BASE_URL_PLACEHOLDER = "Base URL: use * as replacement placeholder"
  URL_SUBSTITUTIONS_PLACEHOLDER = "URL substitutions, space separated replacements or inclusive integer range n-m"
  URLS_PLACEHOLDER = "Alternatively: full URLs for parts, one per line"
  PARENT_PLACEHOLDER = "Enter name of existing or new (unique name) parent"

  has_and_belongs_to_many :genres, :uniq => true
  has_and_belongs_to_many :authors, :uniq => true
  belongs_to :parent, :class_name => "Page"
  belongs_to :ultimate_parent, :class_name => "Page"

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls

  before_validation :remove_placeholders

  validates_presence_of :title, :message => "can't be blank or 'Title'"
  validates_format_of :url, :with => URI.regexp, :allow_blank => true
  validates_uniqueness_of :url, :allow_blank => true

  after_create :initial_fetch

  def self.last_created
    self.order('created_at ASC').last
  end

  def self.find_random
    count = self.count
    return nil if count == 0
    offset = rand(count)
    page = self.where(:parent_id => nil).offset(offset).first
  end

  def self.filter(params={})
    pages = Page.scoped
    pages = pages.where(:last_read => nil) if params[:unread] == "yes"
    pages = pages.where('pages.last_read is not null') if params[:unread] == "no" || params[:sort_by] == "last_read"
    pages = pages.where(:favorite => 1) if params[:favorite] == "yes"
    pages = pages.where(:favorite => [0,2,3,9]) if params[:favorite] == "no"
    pages = pages.where(:favorite => 2) if params[:favorite] == "good"
    pages = pages.where(:favorite => 9) if params[:favorite] == "reading"
    pages = pages.where(:favorite => [1,2]) if params[:favorite] == "either"
    pages = pages.where(:size => "short") if params[:size] == "short"
    pages = pages.where(:size => "medium") if params[:size] == "medium"
    pages = pages.where(:size => "long") if params[:size] == "long"
    pages = pages.where(:size => ["medium", "long"]) if params[:size] == "either"
    [:title, :notes, :url].each do |attrib|
      pages = pages.search(attrib, params[attrib]) if params.has_key?(attrib)
    end
    pages = pages.with_genre(params[:genre]) if params.has_key?(:genre)
    pages = pages.with_author(params[:author]) if params.has_key?(:author)
    # can only find parts by title, notes, url, unread, or last_created.
    unless params[:title] || params[:notes] || params[:url] ||
           params[:unread] == "yes" || params[:sort_by] == "last_created"
      # all other searches find parents only
      pages = pages.where(:parent_id => nil)
    end
    pages = case params[:sort_by]
      when "last_read"
        pages.order('last_read ASC')
      when "random"
        unless params[:unread] == "yes"
          # unless I'm deliberately looking for unreads
          # when I want random fics I don't want really recent read ones
          pages = pages.where('pages.last_read < ?', 1.year.ago)
        end
        pages.order('RAND()')
      when "last_created"
        pages.order('created_at DESC')
      else
        pages.order('read_after ASC')
    end
    pages.group(:id).limit(LIMIT)
  end

  def clean_title
    clean = self.title.gsub('/', '').gsub("'", '').gsub("?", '').gsub(",", '').gsub(":", '').gsub('"', '').gsub("#", '').gsub(" ", "_").gsub("&", "").gsub("(", "").gsub(")", "")
    CGI::escape(clean).gsub('+', ' ').gsub('.', ' ')
  end

  def to_param
    "#{self.id}-#{self.clean_title}"
  end

  def fetch
    begin
      self.raw_html = Scrub.fetch(self.url)
    rescue Mechanize::ResponseCodeError
      self.errors.add(:base, "error retrieving content")
    rescue SocketError
      self.errors.add(:base, "couldn't resolve host name")
    end
    self.get_ao3_meta if self.url.match(/archiveofourown/)
  end

  def get_ao3_meta
    doc = Nokogiri::HTML(Scrub.fetch(self.url))
    doc_title = doc.at_xpath("//h2[@class = 'title heading']").text.strip
    self.title = doc_title if self.title == "Title"
    doc_summary = doc.at_xpath("//div[@class = 'summary module']").text.gsub('Summary:','').strip  rescue ""
    doc_notes = doc.at_xpath("//div[@class = 'notes module']").text.gsub('Notes:','').strip  rescue ""
    doc_end_notes = doc.at_xpath("//div[@class = 'end notes module']").text.gsub('Notes:','').strip  rescue ""
    unless self.parent # don't get authors for subparts
      doc_author = doc.at_xpath("//h3[@class = 'byline heading']").text.strip
      t = Author.arel_table
      mp_author = Author.where(t[:name].matches("#{doc_author}%")).first
      if mp_author
        self.authors = [mp_author]
        doc_author = ""
      else
        self.authors = []
        doc_author = "by #{doc_author}"
      end
    end
    if self.parent && !(self.position == 1) # don't put summary on part one - it's redundant
      self.notes = [doc_summary, doc_notes, doc_end_notes].join("\n\n").strip
    elsif !self.parent
      self.notes = [doc_author, doc_summary, doc_notes, doc_end_notes].join("\n\n").strip
    end
    self.save
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
    parent.set_wordcount(false)
  end

  def parts
    Page.order(:position).where(["parent_id = ?", id])
  end

  def url_list
    partregexp = /\APart \d+\Z/
    list = []
    self.parts.each do |part|
      if part.parts.blank?
        line = part.url
        unless part.title.match(partregexp)
          line = "" unless line
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
    pages=Page.where(["title LIKE ?", "%" + title + "%"])
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
    parent.set_wordcount(false)
    return parent
  end

  def make_first
    earliest = Page.where(:parent_id => nil).order(:read_after).first.read_after || Date.today
    self.update_attribute(:read_after, earliest - 1.day)
    if self.parent
      parent = self.parent
      parent.update_attribute(:read_after, earliest - 1.day) if parent
      grandparent = parent.parent if parent
      grandparent.update_attribute(:read_after, earliest - 1.day) if grandparent
    end
    return self
  end

  def make_reading
    latest = Page.where(:parent_id => nil).order(:read_after).last.read_after + 1.day || Date.tomorrow
    self.update_attribute(:read_after, latest)
    self.update_attribute(:favorite, 9)
    if self.parent
      parent = self.parent
      parent.update_attribute(:read_after, latest) if parent
      parent.update_attribute(:favorite, 9) if parent
      grandparent = parent.parent if parent
      grandparent.update_attribute(:read_after, latest) if grandparent
      grandparent.update_attribute(:favorite, 9) if grandparent
    end
    return self
  end

  def update_rating(string, update_favorite=true)
    self.last_read = Time.now
    self.favorite = case string
      when "1"
        1
      when "2"
        2
      when "3"
        3
      else
        0
    end if update_favorite
    self.read_after = Time.now + string.to_i.send(DURATION)
    self.save
    self.parent.update_rating(string, false) if self.parent
    self.parts.each {|p| p.update_rating(string, true)} if update_favorite
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

  def tag_names(include_date = true)
    names = self.authors.map(&:name) + self.genres.map(&:name) + [self.size]
    names = names + case self.favorite
      when 1
        [FAVORITE]
      when 2
        [GOOD]
      when 3
        ["okay"]
      when 9
        ["reading"]
      else
        []
    end
    names = names + [(self.last_read ? self.last_read.to_date : UNREAD)] if include_date
    names.compact
  end

  def tag_string
    mine = self.tag_names
    if self.parent
      mine = mine - self.parent.tag_names
    end
    mine.join(", ")
  end

  def download_tag_string
    mine = self.tag_names(false)
    if self.parent
      mine = mine - self.parent.tag_names
    end
    mine.join(", ")
  end

  def clean_html_file_name
    Rails.public_path +  self.mypath + "original.html"
  end

  def clean_html=(content)
    ensure_path
    remove_outdated_downloads
    File.open(self.clean_html_file_name, 'w:utf-8') { |f| f.write(content) }
  end

  def clean_html
    self.re_sanitize if self.sanitize_version < Scrub.sanitize_version
    if parts.blank?
      begin
        File.open(self.clean_html_file_name, 'r:utf-8') { |f| f.read }
      rescue Errno::ENOENT
        ""
      end
    end
  end

  def re_sanitize
    Rails.logger.debug "re_sanitizing #{self.id}"
    if !self.parts.blank?
      self.parts.each {|p| p.re_sanitize if p.sanitize_version < Scrub.sanitize_version}
    else
      html = self.clean_html
      self.clean_html = Scrub.sanitize_html(html)
      self.set_wordcount
    end
    self.update_attribute(:sanitize_version, Scrub.sanitize_version)
  end

  def ensure_path
    FileUtils.mkdir_p(Rails.public_path +  self.mypath)
  end

  def raw_html=(content)
    ensure_path
    remove_outdated_downloads
    body = Scrub.regularize_body(content)
    File.open(self.raw_file_name, 'w:utf-8') { |f| f.write(body) }
    html = MyWebsites.getnode(body, self.url)
    if html
      self.clean_html = Scrub.sanitize_html(html)
    else
      self.clean_html = ""
    end
    self.set_wordcount
  end

  def raw_html
    begin
      File.open(self.raw_file_name, 'r:utf-8') { |f| f.read }
    rescue Errno::ENOENT
      ""
    end
  end

  def raw_file_name
    Rails.public_path + self.mypath + "raw.html"
  end

  def rebuild_from_raw
    if self.parts.size > 0
      self.parts.each {|p| p.rebuild_from_raw }
    else
      self.raw_html = self.raw_html
    end
  end

  def remove_surrounding_div!
    self.clean_html = Scrub.remove_surrounding(self.clean_html)
  end

  def top_nodes
    html = self.clean_html
    nodeset = Nokogiri::HTML(html).xpath('//body').children
    nodeset[0, 20].map {|n| n.to_s.chomp }
  end

  def bottom_nodes
    html = self.clean_html
    nodeset = Nokogiri::HTML(html).xpath('//body').children
    nodeset = nodeset[-20, 20] || nodeset
    nodeset.map {|n| n.to_s.chomp }
  end

  def remove_nodes(top, bottom)
    html = self.clean_html
    nodeset = Nokogiri::HTML(html).xpath('//body').children
    top.to_i.times { nodeset.shift }
    bottom.to_i.times { nodeset.pop }
    self.clean_html=nodeset.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    self.set_wordcount
  end

  def formatted_notes
    return "" unless self.notes
    text = "<p>" + self.notes + "</p>"
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "<p></p>")  # 2+ newline  -> paragraph
    text.gsub!(/\n/, "<br \>")  # 2+ newline  -> paragraph
    text
  end

  def short_notes
    return self.notes if self.notes.blank?
    return self.notes if self.notes.size < MININOTE
    snip_idx = self.notes.index(/\s/, MININOTE)
    return self.notes unless snip_idx
    self.notes[0, snip_idx] + "..."
  end


### Download helper methods

  def remove_outdated_downloads(recurse = false)
    Rails.logger.debug "remove outdated downloads for #{self.id}"
    FileUtils.rm_rf(self.download_dir)
    self.parent.remove_outdated_downloads(true) if self.parent
    self.parts.each { |part| part.remove_outdated_downloads(true) unless recurse}
  end

  def download_dir
    "#{Rails.public_path}#{self.mypath}downloads/"
  end
  # needs to be filesystem safe and not overly long
  def download_title
    string = self.title.encode('ASCII', :invalid => :replace, :undef => :replace, :replace => '')
    string = string.gsub(/[^[\w _-]]+/, '')
    string.gsub(/ +/, " ").strip.gsub(/^(.{24}[\w.]*).*/) {$1}
  end
  def download_basename
    "#{self.download_dir}#{self.download_title}"
  end

  def create_epub
    return if File.exists?("#{self.download_basename}.epub")
    cmd = %Q{cd "#{self.download_dir}"; ebook-convert "#{self.download_basename}.html" "#{self.download_basename}.epub" --output-profile ipad --title "#{self.title}" --authors "#{self.download_tag_string}" }
    Rails.logger.debug cmd
    `#{cmd} 2> /dev/null`
  end

private

  def self.search(symbol, string)
    query = "%#{string}%"
    where("pages.#{symbol.to_s} LIKE ?",query)
  end

  def self.with_genre(string)
    joins(:genres).
    where("genres.name = ?", string)
  end

  def self.with_author(string)
    joins(:authors).
    where("authors.name = ?", string)
  end

  def remove_placeholders
    self.url = self.url == "URL" ? nil : self.url.try(:strip)
    self.title = nil if self.title == "Title" unless (self.url && self.url.match('archiveofourown'))
    self.notes = nil if self.notes == "Notes"
    # during testing Notes gets "\n" prepended
    self.notes = nil if self.notes == "\nNotes"
    self.base_url = nil if self.base_url == BASE_URL_PLACEHOLDER
    self.url_substitutions = nil if self.url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    self.urls = nil if self.urls == URLS_PLACEHOLDER
    self.read_after = Time.now if self.read_after.blank?
    self.sanitize_version = Scrub.sanitize_version
  end

  def initial_fetch
    Rails.logger.debug "initial fetch for #{self.id}"
    self.raw_html = "" # make sure raw_html is blank during tests
    if !self.url.blank?
      if self.url.match(/archiveofourown/) && !self.url.match(/chapter/)
        doc = Nokogiri::HTML(Scrub.fetch(self.url + "/navigate"))
        chapter_list = doc.xpath("//ol//a")
        if chapter_list.size == 1
          self.fetch
        else
          count = 1
          chapter_list.each do |element|
            title = element.text
            url = "http://archiveofourown.org" + element['href']
            Page.create(:title => title, :url => url, :position => count, :parent_id => self.id)
            count = count.next
          end
          doc = Nokogiri::HTML(Scrub.fetch(self.url))
          self.update_attribute(:title, doc.at_xpath("//h2").children.text.strip)
          self.set_wordcount
        end
        self.get_ao3_meta
      else
        self.fetch
      end
    elsif !self.base_url.blank?
      count = 1
      match = self.url_substitutions.match("-")
      if match
        array = match.pre_match.to_i .. match.post_match.to_i
      else
        array = self.url_substitutions.split
      end
      array.each do |sub|
        title = "Part " + count.to_s
        url = self.base_url.gsub(/\*/, sub.to_s)
        Page.create(:title => title, :url => url, :position => count, :parent_id => self.id)
        count = count.next
      end
      self.set_wordcount
    elsif !self.urls.blank?
      self.parts_from_urls(self.urls)
    else
      raw_html = ""
    end
  end
end
