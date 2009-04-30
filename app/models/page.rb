class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  URL_PLACEHOLDER = "Enter a URL"
  TITLE_PLACEHOLDER = "Enter a Title"

  def self.search(string)
    Page.find(:first, :conditions => ["title LIKE ?", "%" + string + "%"])
  end

  default_scope :order => 'read_after ASC'

  def before_validation
    self.url = nil if self.url == URL_PLACEHOLDER
    self.title = nil if self.title == TITLE_PLACEHOLDER
    self.read_after = Time.now if self.read_after.blank?
  end

  def after_create
    pwd = Curl::External.getpwd(self.url)
    url = Curl::External.geturl(self.url)
    html = Curl::Easy.perform(url) {|c| c.userpwd = pwd}.body_str.gsub('&nbsp;', " ").squish
    FileUtils.mkdir_p(Rails.public_path +  self.mypath)
    self.original_html=Nokogiri::HTML(html).xpath('//body').first.inner_html
  end

  def next
    self.update_attribute(:read_after, Page.last.read_after + 1.minute)
    return Page.first
  end

  def clean_title
    CGI::escape(self.title).gsub('+', '%20') + ".txt"
  end

  def original_html=(content)
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
    file = Rails.public_path +  self.mypath + self.clean_title
    unless File.exists?(file)
      self.mobile_content=self.remove_html
    end
    file
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
