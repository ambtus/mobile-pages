class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  URL_PLACEHOLDER = "Enter a URL"
  TITLE_PLACEHOLDER = "Enter a Title"
  BASE_URL_PLACEHOLDER = "Base URL: use * as replacement placeholder"
  URL_SUBSTITUTIONS_PLACEHOLDER = "URL substitutions, space separated replacements for base URL"
  URLS_PLACEHOLDER = "Alternatively: full URLs for parts, one per line"
  DURATION = "years"

  has_and_belongs_to_many :genres, :uniq => true
  belongs_to :parent, :class_name => "Page"
  default_scope :order => 'read_after ASC'
  named_scope :parents, :conditions => {:parent_id => nil}
  validates_presence_of :title

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls

  def self.search(string)
    Page.find(:first, :conditions => ["title LIKE ?", "%" + string + "%"])
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
      pwd = Curl::External.getpwd(self.url)
      url = Curl::External.geturl(self.url)
      html = Curl::Easy.perform(url) {|c| c.userpwd = pwd}.body_str.gsub('&nbsp;', " ").squish
      self.original_html=Nokogiri::HTML(html).xpath('//body').first.inner_html
    else
      create_parts
    end
  end

  def create_parts
    File.open(self.original_file, 'w') do |file|
      count = 1
      if self.base_url
        self.url_substitutions.split.each do |sub|
          file << "<h1>Part #{count.to_s}</h1>"
          file << create_child(self.base_url.gsub(/\*/, sub), count).original_html
          count = count.next
        end
      else
        self.urls.each do |url|
          url.chomp!
          file << "<h1>Part #{count.to_s}</h1>"
          file << create_child(url, count).original_html
          count = count.next
        end
      end
    end
  end

  def create_child(url, position)
    title = "Part " + position.to_s
    Page.create(:title => title, :url => url, :position => position, :parent_id => self.id)
  end

  def parts
    Page.find(:all, :order => :position, :conditions => ["parent_id = ?", id])
  end

  def next
    self.update_attribute(:read_after, self.read_after + 3.months)
    return Page.first
  end

  def add_to_read_after(string)
    self.update_attribute(:read_after, self.read_after + string.to_i.send(DURATION))
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
    File.open(Rails.public_path +  self.mypath + self.clean_title, 'w') { |f| f.write(content) }
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
    text = original_html
    Tidy.open do |tidy|
      tidy.options.char_encoding = "utf8"
      tidy.options.drop_proprietary_attributes = true
      tidy.options.new_blocklevel_tags = "x-claris-window, x-claris-tagview"
      tidy.options.logical_emphasis = true
      tidy.options.show_body_only = true
      tidy.options.word_2000 = true
      tidy.options.break_before_br = true
      tidy.options.indent = "auto"
      tidy.options.wrap = 0
      text = tidy.clean(text)
    end
    text = text.gsub(/<\/?h1>/, "\#")
    text = text.gsub(/<\/?strong>/, "\*")
    text = text.gsub(/<\/?em>/, "_")
    text = text.gsub(/<\/?strike>/, "==")
    text = text.gsub(/<sup>/, "^")
    text = text.gsub(/<\/sup>/, "")
    text = text.gsub(/<sub>/, "(")
    text = text.gsub(/<\/sub>/, ")")
    text = text.gsub(/<hr>/, "______________________________")
    text = text.gsub(/<\/?div.*?>/, "")
    text = text.gsub(/<\/?p.*?>/, "")
    text.gsub(/ +/, ' ').gsub(/\n+ */, "\n\n").strip
  end

end
