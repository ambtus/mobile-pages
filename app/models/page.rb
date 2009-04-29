class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  URL_PLACEHOLDER = "Enter a URL"
  TITLE_PLACEHOLDER = "Enter a Title"

  def self.search(string)
    Page.find(:first, :conditions => ["title LIKE ?", "%" + string + "%"])
  end

  def before_validation
    self.url = nil if self.url == URL_PLACEHOLDER
    self.title = nil if self.title == TITLE_PLACEHOLDER
  end

  def after_create
    pwd = Curl::External.getpwd(self.url)
    url = Curl::External.geturl(self.url)
    html = Curl::Easy.perform(url) {|c| c.userpwd = pwd}.body_str.gsub('&nbsp;', " ").squish
    self.original_html=Nokogiri::HTML(html).xpath('//body').first.inner_html
  end

  def original_html=(content)
    File.open(self.original_file, 'w') { |f| f.write(content) }
  end

  def original_html
    File.open(self.original_file, 'r') { |f| f.read }
  end

  def original_file
    self.path + "original.html"
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

  def path
    subdir = case Rails.env
               when "test": "test"
               when "development": "development"
               when "production": "files"
             end
    path = (Rails.root + "public" + subdir + (self.id/MODULO).to_s + self.id.to_s).to_s + "/"
    FileUtils.mkdir_p(path)
  end

end
