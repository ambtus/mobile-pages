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
  LIMIT = 10 # number of pages to show in index

  UNREAD = "unread"
  FAVORITE = "favorite"

  SIZES = ["short", "medium", "long", "epic", "any"]

  SHORT_WC = 1000
  LONG_WC = 10000
  EPIC_WC = 80000

  PDF_FONT_SIZES = ["12", "20", "24", "32", "40", "60"] 
  DEFAULT_PDF_FONT_SIZE = "40" 

  def set_wordcount
    wordcount = self.remove_html.scan(/(\w|-)+/).size
    self.size = "medium"
    self.size = "short" if wordcount < SHORT_WC
    self.size = "long" if wordcount > LONG_WC
    self.size = "epic" if wordcount > EPIC_WC
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
    pages = pages.where(:favorite => true) if params[:favorite] == "yes"
    pages = pages.where(:favorite => false) if params[:favorite] == "no"
    pages =  pages.where(:size => params[:size]) if params.has_key?(:size) unless params[:size] == "any"
    [:title, :notes, :url].each do |attrib|
      pages = pages.search(attrib, params[attrib]) if params.has_key?(attrib)
    end
    pages = pages.with_genre(params[:genre]) if params.has_key?(:genre)
    pages = pages.with_author(params[:author]) if params.has_key?(:author)
    # can only find parts by title, notes, url, favorite, unread, or last_created.
    unless params[:title] || params[:notes] || params[:url] ||
           params[:unread] == "yes" || params[:favorite] == "yes" ||
           params[:sort_by] == "last_created"
      # all other searches find parents only
      pages = pages.where(:parent_id => nil)
    end
    pages = case params[:sort_by]
      when "last_read"
        pages.order('last_read ASC')
      when "random"
        pages.order('RAND()')
      when "last_created"
        pages.order('created_at DESC')
      else
        pages.order('read_after ASC')
    end
    pages.group(:id).limit(LIMIT)
  end

  def clean_title
    clean = self.title.gsub('/', '')
    CGI::escape(clean).gsub('+', ' ').gsub('.', ' ')
  end

  def to_param
    "#{self.id}-#{self.clean_title}"
  end

  def pasted=(html)
    self.raw_html = html
    self.build_me(false)
  end

  def fetch(url=self.url)
    return if url.blank?
    self.update_attribute(:url, url) if url != self.url
    agent = Mechanize.new
    auth = MyWebsites.getpwd(url)
    agent.auth(auth[:username], auth[:password]) if auth
    begin
      page = agent.get(MyWebsites.geturl(url))
      if url.match(/livejournal/) && page.forms.first.try(:button).try(:name) == "adult_check"
         form = page.forms.first
         page = agent.submit(form, form.buttons.first)
      end
      self.raw_html = page.body
      self.build_me(false)
    rescue Mechanize::ResponseCodeError
      self.errors.add(:base, "error retrieving content")
    rescue SocketError
      self.errors.add(:base, "couldn't resolve host name")
    end
  end

  def build_me(reclean)
    if !self.parts.blank?
      self.parts.each {|p| p.build_me(reclean)}
    else
      html = reclean ? self.clean_html(false) : self.raw_html
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
    parent.set_wordcount
    return parent
  end

  def make_later
    was = self.read_after || Time.now
    self.update_attribute(:read_after, was + 3.months)
    return Page.where(:parent_id => nil).order(:read_after).first
  end

  def make_first
    earliest = Page.where(:parent_id => nil).order(:read_after).first.read_after || Date.today
    self.update_attribute(:read_after, earliest - 1.day)
    if self.parent
      parent = self.parent
      parent.update_attribute(:read_after, earliest - 1.day) if parent
      grandparent = parent.parent
      grandparent.update_attribute(:read_after, earliest - 1.day) if grandparent
    end
    return self
  end

  def update_rating(string, update_favorite=true)
    self.last_read = Time.now
    self.favorite = (string == "1" ? true : false) if update_favorite
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
    File.open(self.clean_html_file_name, 'w') { |f| f.write(content) }
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

  def clean_html(check=true)
    self.build_me(true) if (check && self.needs_recleaning?)
    if parts.blank?
      begin
        File.open(self.clean_html_file_name, 'r') { |f| f.read }
      rescue Errno::ENOENT
        ""
      end
    else
      self.build_html_from_parts
    end
  end

  def clean_html_file_name
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

  def pdf_file_basename(font_size=DEFAULT_PDF_FONT_SIZE)
    self.mypath + self.clean_title + "-#{font_size}.pdf"
  end

  def pdf_file_name(font_size=DEFAULT_PDF_FONT_SIZE)
    Rails.public_path + self.pdf_file_basename(font_size)
  end

  def pdf_files
    Dir[File.join(Rails.public_path + self.mypath, '*.pdf')]
  end

  def destroy_all_pdfs
    self.pdf_files.each {|f| File.unlink(f)}
  end

  def pdf_html_file_name
    "/tmp/" + self.id.to_s + ".html"
  end

  def pdf_html=(content)
    File.open(self.pdf_html_file_name, 'w') { |f| f.write(content) }
  end

  def pdf_sizes
    sizes = []
    PDF_FONT_SIZES.each do |size|
      sizes << size if File.exists?(pdf_file_name(size))
    end
    sizes
  end

  def nodes
    html = self.clean_html + "<div></div>"
    array = []
    all = Nokogiri::HTML(html).xpath('//body').children
    all.each do |node|
      unless (node.is_a?(Nokogiri::XML::Text) && node.to_html.blank?)
        array << node.to_xhtml(:encoding => 'utf8')
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
    Scrub.html_to_text(self.clean_html)
  end

  def build_html
    self.build_me(true) if self.needs_recleaning?
    html = "<p>" + self.tag_string + "</p>"
    html = html + "<p>" + self.notes + "</p>" unless self.notes.blank?
    html + self.clean_html
  end

  def to_pdf(font_size=DEFAULT_PDF_FONT_SIZE)
    head = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />'
    style_type = '<style type="text/css">'
    style = "#{style_type}
body {font-family: Georgia; font-size: #{font_size}pt}
h1 {page-break-before: always;}
</style>"
    title = "<title>#{self.title}</title>"
    html = head + style + title + "</head><body>" + self.build_html + "</body></html>"
    margins = "-B 0 -L 0 -R 0 -T 0"
    self.pdf_html = html
    system "/usr/local/bin/wkhtmltopdf --quiet #{margins} \"#{self.pdf_html_file_name}\" \"#{self.pdf_file_name(font_size)}\" >/tmp/wkhtml.out 2>&1 &"
  end

  def to_pml
    Scrub.html_to_pml(self.build_html, self.title, self.author_string)
  end

  def pdb_name
    self.id.to_s + ".pdb"
  end
  def ereader_url
    "ereader://pdbs.sidrasue.com/" + self.pdb_name
  end
  def ereader_exists?
    File.exists?("/home/alice/pdbs/" + self.pdb_name)
  end

  def needs_recleaning?
    return true unless File.exists?(self.clean_html_file_name)
    File.mtime(self.clean_html_file_name) < File.mtime(Rails.root + "extras/scrub.rb")
  end

  def short_notes
    return self.notes if self.notes.blank?
    return self.notes if self.notes.size < MININOTE
    snip_idx = self.notes.index(/\s/, MININOTE)
    return self.notes unless snip_idx
    self.notes[0, snip_idx] + "..."
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
    self.title = nil if self.title == "Title"
    self.notes = nil if self.notes == "Notes"
    self.base_url = nil if self.base_url == BASE_URL_PLACEHOLDER
    self.url_substitutions = nil if self.url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    self.urls = nil if self.urls == URLS_PLACEHOLDER
    self.read_after = Time.now if self.read_after.blank?
  end

  def initial_fetch
    FileUtils.mkdir_p(Rails.public_path +  self.mypath)
    self.raw_html = ""
    if self.url
      fetch
    elsif self.base_url
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
    elsif self.urls
      self.parts_from_urls(self.urls)
    end
  end

end
