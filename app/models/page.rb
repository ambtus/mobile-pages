# encoding=utf-8

class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  COUNT = 150 # words in an edited section

  def mypath
    prefix = case Rails.env
      when "test"; "/tmp/test/"
      when "development"; "/tmp/development/"
      when "production"; "/files/"
    end
    prefix + (self.id/MODULO).to_s + "/" + self.id.to_s + "/"
  end
  def mydirectory
    if Rails.env.production?
      Rails.public_path + mypath
    else
      mypath
    end
  end
  DOWNLOADS = "downloads/"
  def download_dir
    mydirectory + DOWNLOADS
  end
  def download_url(format)
    "#{mypath}#{DOWNLOADS}/#{download_title}#{format}".gsub(' ', '%20')
  end

  HIDDEN = "audio"
  DURATION = "years"
  MININOTE = 75 # keep first this many characters plus enough for full words
  LIMIT = 15 # number of pages to show in index

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
  has_and_belongs_to_many :hiddens, :uniq => true
  has_and_belongs_to_many :authors, :uniq => true
  belongs_to :parent, :class_name => "Page"
  belongs_to :ultimate_parent, :class_name => "Page"

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls
  attr_accessor :file

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
    case params[:favorite]
      when "yes"
        pages = pages.where(:favorite => [0,1])
        pages = pages.where('pages.last_read is not null')
      when "good"
        pages = pages.where(:favorite => 2)
      when "either"
        pages = pages.where(:favorite => [0,1,2])
        pages = pages.where('pages.last_read is not null')
      when "neither"
        pages = pages.where('pages.favorite != ?', 0)
        pages = pages.where('pages.favorite != ?', 1)
        pages = pages.where('pages.favorite != ?', 2)
      when "unfinished"
        pages = pages.where(:favorite => 9)
    end
    pages = pages.where(:nice => [0]) if params[:find] == "sweet" || params[:find] == "both"
    pages = pages.where(:interesting => [0]) if params[:find] == "interesting" || params[:find] == "both"
    pages = pages.where(:size => "short") if params[:size] == "short"
    pages = pages.where(:size => "medium") if params[:size] == "medium"
    pages = pages.where(:size => "long") if params[:size] == "long"
    pages = pages.where(:size => ["medium", "long"]) if params[:size] == "either"
    [:title, :notes, :url].each do |attrib|
      pages = pages.search(attrib, params[attrib]) if params.has_key?(attrib)
    end
    pages = pages.search(:cached_genre_string, params[:genre]) if params.has_key?(:genre)
    pages = pages.search(:cached_genre_string, params[:genre2]) if params.has_key?(:genre2)
    if params.has_key?(:hidden)
      unless params[:hidden] == "any"
        pages = pages.search(:cached_hidden_string, params[:hidden])
      end
    else
      pages = pages.where(:cached_hidden_string => '')
    end
    pages = pages.with_author(params[:author]) if params.has_key?(:author)
    # can only find parts by title, notes, url, last_created.
    unless params[:title] || params[:notes] || params[:url] ||
           #no on unread parts. leaving it here in case I change my mind
           #params[:unread] == "yes" ||
           params[:sort_by] == "last_created"
      # all other searches find parents only
      pages = pages.where(:parent_id => nil)
    end
    pages = case params[:sort_by]
      when "last_read"
        pages.order('last_read ASC')
      when "recently_read"
        pages.order('last_read DESC')
      when "random"
        # when I want random fics, unless I'm deliberately asking for them
        unless params[:unread] == "yes"
          # I don't want unread ones, or ones that have been recently read
          pages = pages.where('pages.last_read < ?', 6.months.ago)
        end
        unless params[:find] == "none"
          # and I don't want stressful or boring ones
          pages = pages.where(:nice => [0,1,nil])
          pages = pages.where(:interesting => [0,1,nil])
        end
        unless params[:favorite] == "unfinished"
          # and I don't want unfinished ones
          pages = pages.where('pages.favorite != ?', 9)
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

  def ao3?
    (self.url && self.url.match(/archiveofourown/)) ||
    (self.parts.first && self.parts.first.url && self.parts.first.url.match(/archiveofourown/))
  end
  def ao3_url; self.url || self.parts.first.url.split("/chapter").first; end


  def fetch
    begin
      self.raw_html = Scrub.fetch(self.url)
    rescue Mechanize::ResponseCodeError
      self.errors.add(:base, "error retrieving content")
    rescue SocketError
      self.errors.add(:base, "couldn't resolve host name")
    end
    self.get_meta_from_ao3 if self.ao3?
  end

  def refetch_ao3
    Rails.logger.debug "refetch #{self.id}"
    refetch_chapters_from_ao3
    get_meta_from_ao3(true)
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
            line = "" unless line
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
      parent.cache_genres
      parent.hiddens << self.hiddens
      parent.cache_hiddens
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

  def make_unfinished
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

  def update_rating(interesting_string, nice_string, update_children=true, update_parent=true)
    self.last_read = Time.now
    self.interesting = interesting_string.to_i
    self.nice = nice_string.to_i
    rating = interesting + nice
    self.favorite = rating
    if rating == 0
      self.read_after = Time.now + 6.months
    else
      self.read_after = Time.now + rating.send(DURATION)
    end
    self.save
    self.parent.update_rating(interesting_string, nice_string, false, true) if self.parent && update_parent
    self.parts.each {|p| p.update_rating(interesting_string, nice_string, true, false)} if update_children
    return rating
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

  def cache_genres
    if self.new_record?
      Rails.logger.debug "genres for new record"
      self.cached_genre_string = genre_string
    else
      Rails.logger.debug "caching genres for #{self.id}"
      self.update_attribute(:cached_genre_string, genre_string)
    end
    genre_string
  end

  def add_genres_from_string=(string)
    return if string.blank?
    string.split(",").each do |genre|
      new = Genre.find_or_create_by_name(genre.squish)
      self.genres << new
    end
    self.cache_genres
  end

  def hidden_string
    self.hiddens.map(&:name).join(", ")
  end

  def cache_hiddens
    if self.new_record?
      Rails.logger.debug "hiddens for new record"
      self.cached_hidden_string = hidden_string
    else
      Rails.logger.debug "caching hiddens for #{self.id}"
      self.update_attribute(:cached_hidden_string, hidden_string)
    end
    hidden_string
  end

  def add_hiddens_from_string=(string)
    Rails.logger.debug "adding hiddens: #{string} to #{self.id}"
    return if string.blank?
    string.split(",").each do |hidden|
      new = Hidden.find_or_create_by_name(hidden.squish)
      self.hiddens << new
    end
    self.cache_hiddens
  end

  def favorite_names
    names = case self.favorite
      when 0
        if self.last_read
          ["favorite"]
        else
          []
        end
      when 1
        ["favorite"]
      when 2
        ["good"]
      when 9
        ["unfinished"]
      else
        []
    end
    names = names + ["sweet"] if nice == 0
    names = names + ["interesting"] if interesting == 0
    names = names + ["stressful"] if nice == 2
    names = names + ["boring"] if interesting == 2
    names.sort.compact
  end

  def tag_names(download = false)
    names = self.authors.map(&:name) + self.genres.map(&:name)
    names = names + [self.size] unless download
    names = names + [(self.last_read ? self.last_read.to_date : "unread")] unless download
    names = names + favorite_names
    names.compact
  end

  def tag_string
    mine = self.tag_names
    if self.parent
      mine = mine - self.parent.tag_names
    end
    mine.join(", ")
  end

  def favorite_string
    self.favorite_names.join(", ")
  end

  def download_tag_string
    self.tag_names(true).join(", ")
  end

  def clean_html_file_name
    self.mydirectory + "original.html"
  end

  def clean_html=(content)
    remove_outdated_downloads
    content = Scrub.remove_surrounding(content) if nodes(content).size == 1
    File.open(self.clean_html_file_name, 'w:utf-8') { |f| f.write(content) }
    self.set_wordcount
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

  def read_html
    body = Nokogiri::HTML(self.clean_html).xpath('//body').first
    if body
      count = 0
      section = 0
      now = true
      body.traverse do |node|
        if count == 0 && now
         section += 1
         now = false
         node.add_previous_sibling("<h2 id=section_#{section}><a href=/pages/#{self.id}/edit?section=#{section}>Section #{section}</a> !!!!!SLOW DOWN AND ENUNCIATE!!!!!</h2>")
        end
        if node.text?
          now = true
          words = node.inner_text.gsub(/(['-])+/, "")
          count +=  words.scan(/[a-zA-Z0-9_]+/).size
          count = 0 if count > COUNT
        end
      end
      body.children.to_xhtml
    else
      ""
    end
  end

  def section(number)
    body = Nokogiri::HTML(self.read_html).xpath('//body').first
    first = body.at("h2#section_#{number}")
    last = body.at("h2#section_#{number+1}")
    result = []
    while true do
      break if first.blank?
      first = first.next
      break if first == last
      result << first.to_html
    end
    result.join
  end

  def edit_section(number, new)
    body = Nokogiri::HTML(self.clean_html).xpath('//body').first
    if body
      added = false
      count = 0
      section = 1
      body.traverse do |node|
        if node.text?
          words = node.inner_text.gsub(/(['-])+/, "")
          count +=  words.scan(/[a-zA-Z0-9_]+/).size
          if count > COUNT
            count = 0
            section += 1
          end
          if section == number
            node.parent.remove
          elsif section == number + 1 && !added
            node.parent.add_previous_sibling(new)
            added = true
          end
        end
      end
      if added == false
        Rails.logger.debug "added to end"
        body.children.last.add_next_sibling(new)
      end
      self.clean_html=body.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    else
      ""
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

  def raw_html=(content)
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
    self.mydirectory + "raw.html"
  end

  def rebuild_from_raw
    if self.parts.size > 0
      self.parts.each {|p| p.rebuild_from_raw }
    else
      self.raw_html = self.raw_html
    end
  end

  def nodes(content = clean_html)
    Nokogiri::HTML(content).xpath('//body').children
  end

  def top_nodes
    nodes[0, 20].map {|n| n.to_s.chomp }
  end

  def bottom_nodes
    nodeset = nodes[-20, 20] || nodes
    nodeset.map {|n| n.to_s.chomp }
  end

  def remove_nodes(top, bottom)
    nodeset = nodes
    top.to_i.times { nodeset.shift }
    bottom.to_i.times { nodeset.pop }
    self.clean_html=nodeset.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
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
    short = self.notes.gsub(%r{</?[^>]+?>}, '')
    snip_idx = short.index(/\s/, MININOTE)
    return short unless snip_idx
    short[0, snip_idx] + "..."
  end

  def make_audio
    Rails.logger.debug "marking as audio for #{self.id}"
    read_hidden = Hidden.find_or_create_by_name(HIDDEN)
    last_read_book = read_hidden.pages.order(:read_after).last
    last = last_read_book ? last_read_book.read_after : Date.today
    self.add_hiddens_from_string= HIDDEN
    self.update_attributes(:read_after => last + 1.day, :favorite => 0, :last_read => Time.now)
  end


### Download helper methods

  def remove_outdated_downloads(recurse = false)
    Rails.logger.debug "remove outdated downloads for #{self.id}"
    FileUtils.rm_rf(self.download_dir) unless self.uploaded
    self.parent.remove_outdated_downloads(true) if self.parent
    self.parts.each { |part| part.remove_outdated_downloads(true) unless recurse}
  end

  # needs to be filesystem safe and not overly long
  def download_title
    Rails.logger.debug "getting download title for #{self.id}"
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

  def create_tmpfile
    return unless file
    File.open(tmpfile_name, "wb") { |f| f.write(self.file.read) }
  end

  def tmpfile_name
    raise unless file.original_filename.match(/\.epub$/)
    "/tmp/" + file.original_filename
  end

  def get_meta_from_epub
    Rails.logger.debug "getting meta from epub"
    self.update_attribute(:wordcount, (File.size("#{self.download_basename}.epub") - 95000)/3)
    self.set_wordcount(false)
    cmd = %Q{ebook-meta "#{download_basename}.epub"}
    Rails.logger.debug cmd
    meta_array = `#{cmd}`.split(/[\n]/).map{ |s| s.split(/:/, 2) } #`
    meta = Hash.new
    meta_array.each do |sub_array|
     key = sub_array.first
     value = sub_array.second
     if key.blank?
       Rails.logger.debug "no key for value #{value}"
     elsif value.blank?
       Rails.logger.debug "no value for key #{key}"
     else
       meta[key.strip] = value.strip
     end
    end
    Rails.logger.debug meta
    self.update_attribute(:title, meta["Title"]) if self.title == "Placeholder"
    Rails.logger.debug " epub title is #{self.title}"
    add_author(meta["Author(s)"])
  end

  def add_author(string)
    return if string.blank?
    mp_authors = Author.where('name like ?', "%#{string}%")
    if mp_authors && mp_authors.size == 1
      self.authors << mp_authors.first
    else
      byline = "by #{string}"
      self.notes = self.notes ? [byline,notes].join("\n\n") : byline
      self.update_attribute(:notes, self.notes) unless self.new_record?
      self.notes
    end
  end

  def get_chapters_from_ao3
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
  end

  def refetch_chapters_from_ao3
    doc = Nokogiri::HTML(Scrub.fetch(self.url + "/navigate"))
    chapter_list = doc.xpath("//ol//a")
    Rails.logger.debug "chapter list for #{self.id}: #{chapter_list}"
    if chapter_list.size == 1
      Rails.logger.debug "fetch one chapter"
      self.fetch
    else
      Rails.logger.debug "fetch #{chapter_list.size} chapters"
      url_list = []
      chapter_list.each do |element|
        title = element.text
        url = "http://archiveofourown.org" + element['href']
        url_list << url + "##" + title
      end
      Rails.logger.debug "#{url_list}"
      self.parts_from_urls(url_list.join("\r"))
    end
  end

  #TODO
  def get_chapters_from_ff
  end

  def get_chapters_from_skyehawke
  end

  def get_meta_from_ao3(refetch=false)
    doc = Nokogiri::HTML(Scrub.fetch(self.url))
    doc_title = doc.at_xpath("//h2[@class = 'title heading']").text.strip
    self.title = doc_title if (self.title == "Title" || refetch)
    doc_summary = doc.at_xpath("//div[@class = 'summary module']").text.gsub('Summary:','').strip  rescue ""
    doc_notes = doc.at_xpath("//div[@class = 'notes module']").text.gsub('Notes:','').strip  rescue ""
    doc_end_notes = doc.at_xpath("//div[@class = 'end notes module']").text.gsub('Notes:','').strip  rescue ""
    if !self.parent || !(self.position == 1) # don't put summary on part one - it's redundant
      self.notes = [doc_summary, doc_notes, doc_end_notes].join("\n\n").strip
    end
    unless self.parent # don't get authors for subparts and get after notes for byline
      add_author(doc.at_xpath("//h3[@class = 'byline heading']").text.strip)
    end
    self.save
  end

  def get_meta_from_ff
  end

  def get_meta_from_skyhawke
  end

private

  def self.search(symbol, string)
    query = "%#{string}%"
    where("pages.#{symbol.to_s} LIKE ?",query)
  end

  def self.without_genre(string)
    query = "%#{string}%"
    where("pages.cached_genre_string NOT LIKE ?",query)
  end

  def self.with_author(string)
    joins(:authors).
    where("authors.name = ?", string)
  end

  def remove_placeholders
    self.url = self.url == "URL" ? nil : self.url.try(:strip)
    self.title = nil if self.title == "Title" unless (self.url && self.url.match('archiveofourown'))
    self.title = "Placeholder" if self.file
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
    FileUtils.rm_rf(mydirectory) # make sure directory is empty for testing
    FileUtils.mkdir_p(download_dir) # make sure directory exists
    if file
      self.uploaded = true
      create_tmpfile
      cmd = "mv #{tmpfile_name} \"#{download_basename}.epub\""
      Rails.logger.debug cmd
      `#{cmd}`
      get_meta_from_epub
    elsif !self.url.blank?
      if self.ao3? && !self.url.match(/chapter/)
        self.get_meta_from_ao3
        self.get_chapters_from_ao3
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
      Rails.logger.debug "nothing to do in initial fetch!"
    end
  end


end
