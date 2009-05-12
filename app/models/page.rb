class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  TITLE_PLACEHOLDER = "Enter a Title for the new page"
  URL_PLACEHOLDER = "Enter a URL for a new page"
  PASTED_PLACEHOLDER = "If you paste html here, it will override fetching from the url"
  BASE_URL_PLACEHOLDER = "Base URL: use * as replacement placeholder"
  URL_SUBSTITUTIONS_PLACEHOLDER = "URL substitutions, space separated replacements for base URL"
  URLS_PLACEHOLDER = "Alternatively: full URLs for parts, one per line"
  DURATION = "years"

  has_and_belongs_to_many :genres, :uniq => true
  belongs_to :parent, :class_name => "Page"
  default_scope :order => 'read_after ASC'
  named_scope :parents, :conditions => {:parent_id => nil}
  validates_presence_of :title
  validates_format_of :url, :with => URI.regexp, :allow_blank => true

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls
  attr_accessor :pasted

  def self.search(string)
    d= Page.find(:first, :conditions => ["title LIKE ?", "%" + string + "%"])
    return d if d
    Page.find(:first, :conditions => ["notes LIKE ?", "%" + string + "%"])
  end

  def before_validation
    self.url = nil if self.url == URL_PLACEHOLDER
    self.title = nil if self.title == TITLE_PLACEHOLDER
    self.pasted = nil if self.pasted == PASTED_PLACEHOLDER
    self.base_url = nil if self.base_url == BASE_URL_PLACEHOLDER
    self.url_substitutions = nil if self.url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    self.urls = nil if self.urls == URLS_PLACEHOLDER
    self.read_after = Time.now if self.read_after.blank?
  end

  def after_create
    FileUtils.mkdir_p(Rails.public_path +  self.mypath)
    if !self.pasted.blank?
      self.raw_content = self.pasted
      self.original_html = self.pre_process(self.raw_file_name)
    elsif self.url
      fetch
    elsif self.base_url
      self.create_from_base
    elsif self.urls
      self.parts_from_urls(self.urls)
    else
      self.build_html_from_parts
    end
  end

  def fetch(url=self.url)
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
    self.original_html = self.pre_process(self.raw_file_name)
    self.original_html = Curl::External.getnode(url, self.original_html)
  end

  def pre_process(filename)
    lines = File.readlines(filename).map{|line| line.chomp}
    html = lines.join(" ").gsub(/<\/?span.*?>/, "")
    html = html.gsub(' ', " ")
    html = html.gsub('&nbsp;', " ").squish
    html = html.gsub(/<o:p> <\/o:p>/i, "")
    html = html.gsub(/<p class=Mso.*?>/, "<p>")
    html = html.gsub(/<br ?\/?>\s*?<br ?\/?>/, "<p>")
    html = html.gsub(/<x-claris.*?>/i, "")
    html = html.gsub(/<script.*?>.*?<\/script>/i, "")
    html = html.gsub(/<noscript.*?>.*?<\/noscript>/i, "")
    html = html.gsub(/<form.*?>.*?<\/form>/i, "")
    html = html.gsub(/<!-- .*?>/i, "")
    html = html.gsub(/<\/?table.*?>/, "")
    html = html.gsub(/<\/?tr.*?>/, "")
    html = html.gsub(/<td.*?>/, "<div>")
    html = html.gsub(/<\/td.*?>/, "</div>")
    input = html.match(/charset ?= ?"?utf-8/i) ? "utf8" : "latin1"
    Tidy.open do |tidy|
      tidy.options.input_encoding = input
      tidy.options.output_encoding = "utf8"
      tidy.options.drop_proprietary_attributes = true
      tidy.options.logical_emphasis = true
      tidy.options.show_body_only = true
      tidy.options.word_2000 = true
      tidy.options.break_before_br = true
      tidy.options.indent = "auto"
      tidy.options.wrap = 0
      html = tidy.clean(html)
    end
    return html
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

  def parts_from_urls(new_urls)
    old_part_ids = self.parts.map(&:id)
    count = 1
    new_part_ids = []
    new_urls.each do |url|
      url.chomp!
      part = Page.find_by_url_and_parent_id(url, self.id)
      if part
        part.title = "Part #{count.to_s}" if part.title.match(/^Part /)
        part.position = count
        part.save
      else
        title = "Part " + count.to_s
        part = create_child(url, count, title)
      end
      new_part_ids << part.id
      count = count.next
    end
    (old_part_ids - new_part_ids).each {|i| Page.find(i).destroy}
    self.build_html_from_parts
  end

  def build_html_from_parts
    File.open(self.original_file, 'w') do |file|
      self.parts.each do |part|
        file << "\n\n<h1>#{part.title}</h1>\n"
        file << part.original_html
      end
    end
  end

  def create_child(url, position, title)
    Page.create(:title => title, :url => url, :position => position, :parent_id => self.id)
  end

  def parts
    Page.find(:all, :order => :position, :conditions => ["parent_id = ?", id])
  end

  def url_list
    self.parts.map(&:url).join("\n")
  end

  def add_parent(title)
    pages=Page.find(:all, :conditions => ["title LIKE ?", "%" + title + "%"])
    return false if pages.size > 1
    parent = nil
    if pages.size == 0
      parent = Page.create(:title => title)
    else
      parent = pages.first
      return false if parent.parts.blank?
    end
    count = parent.parts.size + 1
    self.update_attributes(:parent_id => parent.id, :position => count)
    parent.build_html_from_parts
    return parent
  end

  def next
    self.update_attribute(:read_after, self.read_after + 3.months)
    return Page.first
  end

  def add_to_read_after(string)
    after = self.read_after + string.to_i.send(DURATION)
    self.update_attributes(:read_after => after, :last_read => Time.now)
    return self.read_after
  end

  def clean_title
    CGI::escape(self.title).gsub('+', '%20') + ".txt"
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
      File.unlink(self.parent.mobile_file_name) rescue Errno::ENOENT
      self.parent.build_html_from_parts
    end
  end

  def original_html
    File.open(self.original_file, 'r') { |f| f.read }
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
    File.open(self.raw_file_name, 'r') { |f| f.read }
  end

  def raw_file_name
    Rails.public_path + self.mypath + "raw.html"
  end

  def mypath
    env = case Rails.env
      when "test": "/test/"
      when "development": "/development/"
      when "production": "/files/"
    end
    env + (self.id/MODULO).to_s + "/" + self.id.to_s + "/"
  end

  def nodes
    Nokogiri::HTML(self.original_html).xpath('//body').first.children
  end

  def remove_nodes(ids)
    scrubbed = []
    self.nodes.each_with_index do |node,index|
      scrubbed << node unless ids.include?(index.to_s)
    end
    self.original_html=scrubbed
  end

  def remove_html
    text = self.original_html
    text = text.gsub(/<\/?font.*?>/, "")
    text = text.gsub(/<\/?center>/, "")
    text = text.gsub(/<\/?wbr>/, "")
    text = text.gsub(/<h1>(.*?)<\/h1>/) {|s| "\# #{$1} \#" unless $1.blank?}
    text = text.gsub(/<\/?h\d.*?>/, "\*")
    text = text.gsub(/<\/?strong>/, "\*")
    text = text.gsub(/<\/?big>/, "\*")
    text = text.gsub(/<\/?em.*?>/, "_")
    text = text.gsub(/<\/?u>/, "_")
    text = text.gsub(/_([ ,.?]+)_/) {|s| $1}
    text = text.gsub(/\*([ ,.?]+)\*/) {|s| $1}
    text = text.gsub(/<\/?strike>/, "==")
    text = text.gsub(/<sup>/, "^")
    text = text.gsub(/<\/sup>/, "")
    text = text.gsub(/<sub>/, "(")
    text = text.gsub(/<\/sub>/, ")")
    text = text.gsub(/<hr.*?>/, "______________________________")
    text = text.gsub(/<\/?div.*?>/, "")
    text = text.gsub(/<\/?[uod]l.*?>/, "")
    text = text.gsub(/<\/?dd.*?>/, "")
    text = text.gsub(/<li.*?>/, "* ")
    text = text.gsub(/<\/?li.*?>/, "")
    text = text.gsub(/<dt.*?>/, "")
    text = text.gsub(/<\/?dt.*?>/, ": ")
    text = text.gsub(/<\/?blockquote.*?>/, "")
    text = text.gsub(/<\/?p.*?>/, "")
    text = text.gsub(/<\/?br.*?>/, "")
    text = text.gsub(/<a.*?>(.*?)<\/a>/) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<img.*?alt="(.*?)".*?>/) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<img.*?>/, "")
    text.gsub(/ +/, ' ').gsub(/\n+ */, "\n\n").strip
  end

end
