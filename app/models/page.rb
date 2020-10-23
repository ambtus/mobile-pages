# encoding=utf-8

class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory

  def self.remove_all_downloads
    self.all.each do |page|
      page.remove_outdated_downloads
    end;1
  end

  def self.remove_all_duplicate_tags
    Page.where.not(parent_id: nil).each do |page|
      page.remove_duplicate_tags
    end
  end

  def remove_duplicate_tags
    return unless self.parent #TODO raise error or at least log a problem
    dups = self.tags & self.parent.tags
    self.tags.delete(dups)
    self.cache_tags
  end

  def mypath
    prefix = case Rails.env
      when "test"; "/tmp/test/"
      when "development"; "/tmp/files/"
      when "production"; "/files/"
    end
    prefix + (self.id/MODULO).to_s + "/" + self.id.to_s + "/"
  end
  def mydirectory
    if Rails.env.production?
      Rails.public_path.to_s + mypath
    elsif Rails.env.development?
      Rails.root.to_s + mypath
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

  UNREAD = "unread"
  SHORT_LENGTH = 160 # truncate at this many characters
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
      body = Nokogiri::HTML(self.edited_html).xpath('//body').first
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

  has_and_belongs_to_many :tags, -> { distinct }
  has_and_belongs_to_many :authors, -> { distinct }
  belongs_to :parent, class_name: "Page", optional: true
  belongs_to :ultimate_parent, class_name: "Page", optional: true

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls

  before_validation :remove_placeholders

  validates_presence_of :title, :message => "can't be blank or 'Title'"
  validates_format_of :url, :with => URI.regexp, :allow_blank => true
  validates_uniqueness_of :url, :allow_blank => true, :case_sensitive => false

  after_create :initial_fetch

  # used in tests
  def self.create_from_hash(hash)
    Rails.logger.debug "DEBUG: Page.create_from_hash(#{hash})"
    tag_types = Hash.new("")
    Tag.types.each {|tag_type| tag_types[tag_type] = hash.delete(tag_type.downcase.pluralize.to_sym) }
    page = Page.create(hash)
    tag_types.each {|key, value| page.send("add_tags_from_string", value, key)}
    if hash[:last_read] # update parts and self
      page.parts.each {|p| p.update_attribute(:last_read, hash[:last_read])}
      page.update_attribute(:last_read, hash[:last_read])
    end
    Rails.logger.debug "DEBUG: created page with tags: [#{page.tags.joined}] and authors: #{page.authors.map(&:true_name)} and last_read: #{page.last_read}"
    page
  end

  def self.filter(params={})
    Rails.logger.debug "DEBUG: Page.filter(#{params})"
    pages = Page.all
    # ignore parts if not filtering on anything
    pages = pages.where(:parent_id => nil) if params == {"controller"=>"pages", "action"=>"index"}
    pages = pages.where(:last_read => nil) if params[:unread] == "yes"
    pages = pages.where('pages.last_read is not null') if params[:unread] == "no" || params[:sort_by] == "last_read"
    # ignore parts if filtering on stars
    pages = pages.where(:parent_id => nil) if params[:favorite]
    case params[:favorite]
      when "yes"
        pages = pages.where(:stars => 5)
      when "best"
        pages = pages.where(:stars => [5,4])
      when "good"
        pages = pages.where(:stars => [5,4,3])
      when "bad"
        pages = pages.where(:stars => [2,1])
      when "unfinished"
        pages = pages.where(:stars => 9)
    end
    # ignore parts if filtering on size
    pages = pages.where(:parent_id => nil) if params[:size]
    pages = pages.where(:size => "short") if params[:size] == "short"
    pages = pages.where(:size => "medium") if params[:size] == "medium"
    pages = pages.where(:size => "long") if params[:size] == "long"
    pages = pages.where(:size => ["medium", "long"]) if params[:size] == "either"
    [:title, :notes, :my_notes].each do |attrib|
      pages = pages.search(attrib, params[attrib]) if params.has_key?(attrib)
    end
    if params.has_key?(:url) # strip the https? in case it was stored under the other
      pages = pages.search(:url, params[:url].sub(/^https?/, ''))
    end
    pages = pages.search(:cached_tag_string, params[:tag]) if params.has_key?(:tag)
    pages = pages.search(:cached_tag_string, params[:fandom]) if params.has_key?(:fandom)
    pages = pages.search(:cached_tag_string, params[:relationship]) if params.has_key?(:relationship)
    pages = pages.search(:cached_tag_string, params[:rating]) if params.has_key?(:rating)
    pages = pages.search(:cached_tag_string, params[:info]) if params.has_key?(:info)
    pages = pages.without_tag(params[:omitted]) if params.has_key?(:omitted)
    if params.has_key?(:hidden)
      pages = pages.search(:cached_hidden_string, params[:hidden])
    elsif params.has_key?(:url)
      # do not constrain on cached_hidden_string if finding by url
    else
      pages = pages.where(:cached_hidden_string => "")
    end
    pages = pages.with_author(params[:author]) if params.has_key?(:author)
    pages = case params[:sort_by]
      when "last_read"
        pages.order('last_read ASC')
      when "recently_read"
        pages.order('last_read DESC')
      when "random"
        # when I want random fics -- unless I'm deliberately asking for them --
        # I don't want unread or unfinished ones, or ones that have been recently read
        unless params[:unread] == "yes" || params[:favorite] == "unfinished"
          pages = pages.where('pages.last_read < ?', 6.months.ago)
        end
        pages.order(Arel.sql('RAND()'))
      when "last_created"
        pages.order('created_at DESC')
      else
        pages.order('read_after ASC')
    end
    start = params[:count].to_i
    pages.group(:id).limit(start + LIMIT)[start..-1]
  end

  def to_param
    "#{self.id}-#{self.download_title}"
  end

  def ao3?
    (self.url && self.url.match(/archiveofourown/)) ||
    (self.parts.first && self.parts.first.url && self.parts.first.url.match(/archiveofourown/))
  end
  def ao3_url; self.url || self.parts.first.url.split("/chapter").first; end
  def ao3_chapter?; self.url && self.url.match(/chapters/); end
  def ao3_series?
     self.url.blank? &&
     self.parts.present? &&
     self.parts.first.ao3? && ! self.parts.first.ao3_chapter?
  end

  def fetch
    remove_outdated_downloads
    remove_outdated_edits
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
    Rails.logger.debug "DEBUG: refetch_ao3 #{self.id}"
    if ao3_chapter?
      self.fetch
    else
      get_chapters_from_ao3
      self.set_wordcount
    end
    get_meta_from_ao3
  end

  def parts_from_urls(url_title_list, refetch=false)
    old_part_ids = self.parts.map(&:id)
    old_subpart_ids = self.parts.collect{|p| p.parts.map(&:id)}.flatten
    Rails.logger.debug "DEBUG: my old parts #{old_part_ids} and subparts #{old_subpart_ids}"

    new_part_ids = []
    new_subpart_ids = []

    lines = url_title_list.split(/[\r\n]/).select {|l| l.chomp}.map(&:squish) - [""]

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

    Rails.logger.debug "DEBUG: find or create parts #{parts}"
    parts.each do |part|
      url = title = position = nil
      url = part.sub(/#.*/, "")
      title = part.sub(/.*#/, "") if part.match("#")
      position = parts.index(part) + 1
      title = "Part #{position}" if title.blank?
      page = Page.find_by(url: url) unless url.blank?
      page = Page.find_by(title: title, parent_id: parent.id) unless page
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
    Rails.logger.debug "DEBUG: parts found or created: #{new_part_ids}"

    Rails.logger.debug "DEBUG: find or create subparts #{subparts}"
    subparts.each do |subpart|
      url = title = position = nil
      part_string = (lines[0..lines.index(subpart)] & parts).last
      part_index = parts.index(part_string)
      position = lines.index(subpart) - lines.index(part_string)
      Rails.logger.debug "DEBUG: part_index: #{part_index} position: #{position}"
      part = Page.find(new_part_ids[part_index])
      url = subpart.sub(/#.*/, "")
      title = subpart.sub(/.*#/, "") if subpart.match("#")
      title = "Part #{position}" if title.blank?
      page = if url.blank?
        part.parts.find {|p| p.title.match(title) }
      else
        page = Page.find_by(url: url)
      end
      if page.blank?
        Rails.logger.debug "DEBUG: creating new page"
        page = Page.create(:url=>url, :title=>title, :parent_id=>part.id, :position => position)
        part.update_attribute(:read_after, Time.now) if part.read_after > Time.now
        parent.update_attribute(:read_after, Time.now) if parent.read_after > Time.now
      else
        Rails.logger.debug "DEBUG: updating page #{page.id}"
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
      new_subpart_ids << page.id
    end
    Rails.logger.debug "DEBUG: subparts found or created: #{new_subpart_ids}"

    remove = old_part_ids + old_subpart_ids - new_part_ids - new_subpart_ids
    Rails.logger.debug "DEBUG: removing deleted parts and subparts #{remove}"
    remove.each do |old_part_id|
      Page.find(old_part_id).destroy
    end

    self.update_last_read
    self.set_wordcount
  end

  def parts; Page.order(:position).where(["parent_id = ?", id]); end

  def not_hidden_parts; parts.select{|part| part.cached_hidden_string.blank?}; end

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

  def make_single
    Rails.logger.debug "DEBUG: removing #{self.parent_id} from #{self.id}"
    return unless parent
    parent = self.parent
    self.tags << parent.tags
    self.cache_tags
    self.authors << parent.authors
    self.update_attribute(:parent_id, nil)
  end

  def add_parent(title)
    parent=Page.find_by_title(title)
    Rails.logger.debug "DEBUG: parent #{title} found? #{parent.is_a?(Page)}"
    new = false
    unless parent.is_a?(Page)
      pages=Page.where(["title LIKE ?", "%" + title + "%"])
      if pages.size > 1
        Rails.logger.debug "DEBUG: #{pages.size} possible parents found"
        return "ambiguous"
      elsif pages.empty? || pages.first == self
        Rails.logger.debug "DEBUG: creating a new parent"
        parent = Page.create!(:title => title, :last_read => self.last_read, :read_after => self.read_after)
        new = true
      else
        Rails.logger.debug "DEBUG: matching parent found #{pages.first.title}"
        parent = pages.first
      end
    end
    return "content" unless parent.raw_html.blank?
    count = parent.parts.size + 1
    self.update(:parent_id => parent.id, :position => count)
    if new
      parent.tags << self.tags.not_hidden.not_omitted.not_relationship.not_info
      parent.cache_tags
      parent.authors << self.authors
      parent.update_attribute(:stars, self.stars)
    else
      Rails.logger.debug "DEBUG: updating parent last read #{parent.last_read}? mine is #{self.last_read}"
      if self.unread? || (parent.read? && self.last_read > parent.last_read)
        parent.update_attribute(:last_read, self.last_read)
      end
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
  def make_last
    latest = Page.where(:parent_id => nil).order(:read_after).last.read_after || Date.today
    self.update_attribute(:read_after, latest + 1.day)
    if self.parent
      parent = self.parent
      parent.update_attribute(:read_after, latest + 1.day) if parent
      grandparent = parent.parent if parent
      grandparent.update_attribute(:read_after, latest + 1.day) if grandparent
    end
    return self
  end

  def make_unfinished
    latest = Page.where(:parent_id => nil).order(:read_after).last.read_after + 1.day || Date.tomorrow
    self.update_attribute(:read_after, latest)
    self.update_attribute(:stars, 9)
    self.update(:last_read => Time.now)
    self.update_read_after
    return self
  end

  def rate(stars, update_parent = true, update_children = true)
    self.stars = stars.to_i
    self.update(:last_read => Time.now)
    self.update_read_after
    self.parts.each {|part| part.rate(stars, false, true)} if update_children
    if self.parent && update_parent; parent.update_last_read; end
    return self.stars
  end

  def update_read_after
    Rails.logger.debug "DEBUG: part last read: #{self.last_read}"
    rating = self.stars
    if rating == 5
      self.read_after = Time.now + 6.months
    elsif rating == 4
      self.read_after = Time.now + 1.year
    elsif rating == 3
      self.read_after = Time.now + 2.years
    elsif rating == 2
      self.read_after = Time.now + 3.years
    elsif rating == 1
      self.read_after = Time.now + 4.years
    elsif rating == 9
      self.read_after = Time.now + 5.years
    end
    self.save
  end

  def update_last_read
    last_reads = self.parts.map(&:last_read)
    if last_reads.include?(nil)
      self.update_attribute(:last_read, nil)
    else
      self.update_attribute(:last_read, last_reads.sort.first)
      self.update_attribute(:stars, self.parts.map(&:stars).sort.last)
      self.update_read_after
    end
    Rails.logger.debug "DEBUG: parent last read: #{self.last_read}"
  end



  def add_author_string=(string)
    return if string.blank?
    string.split(",").each do |possible|
      author = Author.find_by_short_name(possible)
      author = Author.find_or_create_by(name: possible.squish) unless author
      self.authors << author
    end
    self.authors
  end

  def unread?; last_read.blank?; end
  def read?; last_read.present?; end

  # used in show view
  Tag.types.each do |type|
    define_method(type.downcase + "_string") do
      self.tags.where(type: type).by_name.joined
    end
  end
  def trope_string; self.tags.trope.by_name.joined; end #then redefine trope_string
  def author_string; self.authors.joined; end
  def size_string; "#{self.size}: #{ActionController::Base.helpers.number_with_delimiter(self.wordcount)} words"; end
  def last_read_string; unread? ? UNREAD : last_read.to_date; end
  def my_formatted_notes; Scrub.sanitize_html(my_notes); end
  def formatted_notes; Scrub.sanitize_html(notes); end

  # used in index view and in epub comments
  def short_notes; RubyPants.new(Scrub.sanitize_and_strip(notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end
  def my_short_notes; RubyPants.new(Scrub.sanitize_and_strip(my_notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end

  def add_tags_from_string(string, type="Tag")
    return if string.blank?
    type = "Tag" if type == "Trope"
    string.split(",").each do |tag|
      self.tags << type.constantize.find_or_create_by(name: tag.squish)
    end
    self.cache_tags
  end

  def cache_string; self.tags.not_hidden.joined; end
  def cache_tags
    Rails.logger.debug "DEBUG: cache_tags for #{self.id} tags: #{cache_string}, hiddens: #{hidden_string}"
    self.remove_outdated_downloads
    self.update(cached_tag_string: cache_string, cached_hidden_string: hidden_string)
    self.parts.map(&:remove_duplicate_tags)
  end

  def unfinished?; stars == 9; end
  def unrated?; stars == 10; end
  def stars?; [5,4,3,2,1].include?(self.stars); end
  def star_string
    if stars?
      "#{stars} " + "stars".pluralize(stars)
    elsif unfinished?
      "unfinished"
    elsif unrated?
      nil
    else
      Rails.logger.debug "DEBUG: stars are #{self.stars}, should be 5,4,3,2,1,9,or 10"
      "unknown"
    end
  end

  def title_prefix; title.match(position.to_s) ? "" : "#{position}. "; end

  def unread_string; unread? ? UNREAD : ""; end
  def short_diff_strings; [author_string, unread_string, *tags.not_info.by_type.by_name.map(&:name)].reject(&:blank?); end
  def long_diff_strings; [author_string, last_read_string, star_string, size_string, *tags.by_type.by_name.map(&:name)].reject(&:blank?); end

  def show_title_diffs
    mine = long_diff_strings
    if self.parent
      mine = mine - parent.long_diff_strings
    end
    mine
  end
  def merged_tag_string; show_title_diffs.join(', '); end

  def download_title_diffs
    mine = short_diff_strings
    if self.parent
      mine = mine - parent.short_diff_strings
    end
    mine
  end

  def title_suffix; show_title_diffs.empty? ? "" : " (#{merged_tag_string})"; end
  def download_suffix; download_title_diffs.empty? ? "" : " (#{download_title_diffs.join(', ')})"; end

  def download_part_title; title_prefix + title + download_suffix; end

  def section(number)
    body = Nokogiri::HTML(self.edited_html).xpath('//body').first
    if body
      section = 0
      body.traverse do |node|
        if node.text? && !node.blank?
          section += 1
          return node.text if section == number
        end
      end
    else
      ""
    end
  end

  def edit_section(number, new)
    body = Nokogiri::HTML(self.edited_html).xpath('//body').first
    if body
      added = false
      if body
        section = 0
        body.traverse do |node|
          if node.text? && !node.blank?
            section += 1
            if section == number
              node.content = new if section == number
              added = true
              Rails.logger.debug "DEBUG: replaced node text in section #{number}"
              break
            end
          end
        end
      else
        ""
      end
      if added == false
        Rails.logger.debug "DEBUG: added new text to end"
        body.children.last.add_next_sibling(new)
      end
      self.edited_html=body.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    else
      ""
    end
  end


  def re_sanitize
    Rails.logger.debug "DEBUG: re_sanitizing #{self.id}"
    if !self.parts.blank?
      self.parts.each {|p| p.re_sanitize if p.sanitize_version < Scrub.sanitize_version}
    else
      html = self.scrubbed_html
      self.scrubbed_html = Scrub.sanitize_html(html)
      self.set_wordcount
    end
    self.update_attribute(:sanitize_version, Scrub.sanitize_version)
  end

  ## Raw html includes everything from the web

  def raw_html_file_name
    self.mydirectory + "raw.html"
  end

  def raw_html=(content)
    remove_outdated_downloads
    body = Scrub.regularize_body(content)
    File.open(self.raw_html_file_name, 'w:utf-8') { |f| f.write(body) }
    html = MyWebsites.getnode(body, self.url)
    if html
      self.scrubbed_html = Scrub.sanitize_html(html)
    else
      self.scrubbed_html = ""
    end
    self.set_wordcount
  end

  def raw_html
    begin
      File.open(self.raw_html_file_name, 'r:utf-8') { |f| f.read }
    rescue Errno::ENOENT
      ""
    end
  end

  def rebuild_clean_from_raw
    remove_outdated_downloads
    if self.parts.size > 0
      self.parts.each {|p| p.rebuild_clean_from_raw }
    else
      self.raw_html = self.raw_html
    end
  end

  ## Clean html includes all the original text

  def scrubbed_html_file_name
    self.mydirectory + "scrubbed.html"
  end

  def scrubbed_html=(content)
    remove_outdated_downloads
    content = Scrub.remove_surrounding(content) if nodes(content).size == 1
    File.open(self.scrubbed_html_file_name, 'w:utf-8') { |f| f.write(content) }
  end

  def scrubbed_html
    self.re_sanitize if self.sanitize_version < Scrub.sanitize_version
    if parts.blank?
      begin
        File.open(self.scrubbed_html_file_name, 'r:utf-8') { |f| f.read }
      rescue Errno::ENOENT
        ""
      end
    end
  end

  def rebuild_edited_from_clean
    remove_outdated_downloads
    if self.parts.size > 0
      self.parts.each {|p| p.rebuild_edited_from_clean }
    else
      FileUtils.rm_f(edited_html_file_name)
    end
  end

  ### scrubbing (removing top and bottom nodes) is done on clean text

  def nodes(content = scrubbed_html)
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
    self.scrubbed_html=nodeset.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    self.set_wordcount
  end

  def edited_html_file_name
    self.mydirectory + "edited.html"
  end

  def edited_html=(content)
    remove_outdated_downloads
    File.open(self.edited_html_file_name, 'w:utf-8') { |f| f.write(content) }
    self.set_wordcount
  end

  ## but if it doesn't exist (I haven't edited) use the scrubbed version
  def edited_html
    if parts.blank?
      begin
        File.open(self.edited_html_file_name, 'r:utf-8') { |f| f.read }
      rescue Errno::ENOENT
        begin
          File.open(self.scrubbed_html_file_name, 'r:utf-8') { |f| f.read }
        rescue Errno::ENOENT
          ""
        end
      end
    end
  end

  ### Read html is what I would read for an audio book, and also how I edit

  def read_html
    body = Nokogiri::HTML(self.edited_html).xpath('//body').first
    if body
      section = 0
      body.traverse do |node|
        if node.text? && !node.blank?
          node.add_previous_sibling("<h2>!!!!!SLOW DOWN AND ENUNCIATE!!!!!</h2>") if section % 10 == 0 || section == 0
          section += 1
          node.add_previous_sibling("<a id=section_#{section} href=/pages/#{self.id}/edit?section=#{section}>#{section}</a>")
        end
      end
      body.children.to_xhtml
    else
      ""
    end
  end

  def make_audio  # add an audio tag and mark it as read today
    Rails.logger.debug "DEBUG: mark_audio for #{self.id}"
    self.add_tags_from_string("audio book")
    self.update(:last_read => Time.now)
    self.update_read_after
  end

  ## Download helper methods

  def remove_outdated_downloads(recurse = false)
    FileUtils.rm_rf(self.download_dir)
    FileUtils.mkdir_p(self.download_dir)
    self.parent.remove_outdated_downloads(true) if self.parent
    self.parts.each { |part| part.remove_outdated_downloads(true) unless recurse}
  end

  def remove_outdated_edits
    FileUtils.rm_f(self.scrubbed_html_file_name)
    FileUtils.rm_f(self.edited_html_file_name)
  end

  # needs to be filesystem safe and not overly long
  def download_title
    string = self.title.encode('ASCII', :invalid => :replace, :undef => :replace, :replace => '')
    string = string.gsub(/[^[\w _-]]+/, '')
    string.gsub(/ +/, " ").strip.gsub(/^(.{30}[\w.]*).*/) {$1}
  end
  def download_basename
    "#{self.download_dir}#{self.download_title}"
  end

  ## --authors
  ## if it's hidden, then hide the authors also
  ## if it's not, use the short names
  ## if it's a part, add the parent's authors
  def all_authors;
    my_authors = self.authors
    my_parents_authors = self.parent_id.blank? ? [] : self.parent.all_authors
    (my_authors + my_parents_authors).pulverize.sort_by{|a| a.name}
  end
  def all_authors_string; all_authors.map(&:true_name).join(" & "); end
  def hidden?; cached_hidden_string.present?; end
  def download_author_string; hidden? ? "" : all_authors_string; end
  ## --tags
  ## if it's hidden, then the hidden tags are the only tags
  ## if it's not hidden, then add size and unread (if not read) to not-series tags
  ## if it's a part, add the parent's tags
  def download_tags;
    [(unread? ? UNREAD : ""),
     *tags.not_fandom.not_relationship.not_info.map(&:name),
     ]
  end
  def all_tags;
    my_tags = download_tags
    my_parents_tags = self.parent_id.blank? ? [] : self.parent.all_tags
    (my_tags + my_parents_tags).pulverize
  end
  def download_tag_string; hidden? ? cached_hidden_string : "#{size}, #{all_tags.join_comma}"; end
  ## --series
  ## if it has exactly one relationship, then use that
  ## else if it has more than one fandom, then use "crossover"
  ## else use the fandom
  def all_fandoms;
    my_fandoms = tags.fandom
    my_parents_fandoms = self.parent_id.blank? ? [] : self.parent.all_fandoms
    (my_fandoms + my_parents_fandoms).pulverize
  end
  def all_relationships;
    my_relationships = tags.relationship
    my_parents_relationships = self.parent_id.blank? ? [] : self.parent.all_relationships
    (my_relationships + my_parents_relationships).pulverize
  end
  def fandom_name; all_fandoms.present? ? all_fandoms.first.name : ""; end
  def relationship_name; all_relationships.present? ? all_relationships.first.name : ""; end
  def crossover?; all_fandoms.size > 1; end
  def download_fandom_string
    if all_relationships.size == 1
      relationship_name
    else
      crossover? ? "crossover" : fandom_name;
    end
  end
  ## --comments
  ## if it's hidden, then put the authors (if they exist) into the comments with the hidden tags
  def hidden_comment_string
    return "" unless hidden?
    return hidden_string unless all_authors_string.present?
    "by #{all_authors_string}, #{hidden_string}"
  end
  def all_tags_for_comments
    my_tags = self.tags.fandom.by_name + self.tags.relationship.by_name + self.tags.trope.by_name
    my_parents_tags = self.parent_id.blank? ? [] : self.parent.all_tags_for_comments
    (my_tags + my_parents_tags).pulverize
  end
  def all_tags_for_comments_string
    fandoms = all_tags_for_comments.select{|t| t.type == "Fandom"}
    relationships = all_tags_for_comments.select{|t| t.type == "Relationship"}
    tropes = all_tags_for_comments.select{|t| t.type == ""}
    (fandoms + relationships + tropes).map(&:name).join_comma
  end
  def download_comment_string
    [
      hidden_comment_string,
      all_tags_for_comments_string,
      size_string,
      my_short_notes,
      short_notes,
    ].join_comma
  end

  def epub_tags
    string = %Q{--title "#{self.title}"}
    unless self.download_author_string.blank?
      string = string + %Q{ --authors "#{self.download_author_string}"}
    end
    if self.stars?
      string = string + %Q{ --rating "#{self.stars*2}" }
    end
    unless self.download_tag_string.blank?
      string = string + %Q{ --tags "#{self.download_tag_string}"}
    end
    if self.download_fandom_string.present? && self.cached_hidden_string.blank?
      string = string + %Q{ --series "#{self.download_fandom_string}"}
    end
    unless self.download_comment_string.blank?
      string = string + %Q{ --comments "#{self.download_comment_string}"}
    end
    string
  end
  def epub_command
     cmd = %Q{cd "#{self.download_dir}"; ebook-convert "#{self.download_basename}.html" "#{self.download_basename}.epub" --no-default-epub-cover } + epub_tags
    Rails.logger.debug "DEBUG: #{cmd}"
    # Rails.logger.debug "DEBUG: #{epub_tags}"
    return cmd
  end

  def create_epub
    return if File.exists?("#{self.download_basename}.epub")
    FileUtils.mkdir_p(download_dir) # make sure directory exists
    `#{epub_command} 2> /dev/null`
  end

  def add_author(string)
    return if string.blank?
    try = string.split(" (").first
    tries = try.split(", ")
    mp_authors = []
    non_mp_authors = []
    tries.each do |t|
      found = Author.where('name like ?', "%#{t}%")
      if found.blank?
        non_mp_authors << t
      else
        mp_authors << found
      end
    end
    mp_authors.each {|a| self.authors << a}
    unless non_mp_authors.empty?
      byline = "by #{non_mp_authors.join(", ")}"
      if self.notes.blank?
        self.notes = byline
      elsif !self.notes.match(byline)
        self.notes = [byline,notes].join("\n\n")
      else
        return self.notes
      end
      self.update_attribute(:notes, self.notes) unless self.new_record?
      self.notes
    end
    self.remove_outdated_downloads
  end

  def ao3_doc_title(doc); doc.xpath("//h2").last.children.text.strip rescue "empty title"; end
  def ao3_single_chapter_fic_title(doc)
    doc.css(".chapter .title").children.last.text.strip.gsub(": ","") rescue nil
  end
  def ao3_chapter_title(doc, position)
    chapter_title = doc.css(".chapter .title").children.last.text.strip rescue nil
    if chapter_title.blank?
      "Chapter #{position}"
    else
      chapter_title.gsub(/^: /,"")
    end
  end

  def get_chapters_from_ao3
    Rails.logger.debug "DEBUG: getting chapters from ao3 for #{self.id}"
    doc = Nokogiri::HTML(Scrub.fetch(self.url + "/navigate"))
    chapter_list = doc.xpath("//ol//a")
    Rails.logger.debug "DEBUG: chapter list for #{self.id}: #{chapter_list}"
    if chapter_list.size == 1
      Rails.logger.debug "DEBUG: only one chapter"
      self.fetch
    else
      count = 1
      chapter_list.each do |element|
        title = element.text
        url = "http://archiveofourown.org" + element['href']
        chapter = Page.find_by(url: url)
        if chapter
          if chapter.position == count && chapter.parent_id == self.id
            Rails.logger.debug "DEBUG: chapter already exists, skipping #{chapter.id} in position #{count}"
          else
            Rails.logger.debug "DEBUG: chapter already exists, updating #{chapter.id} with position #{count}"
            chapter.update(position: count, parent_id: self.id)
          end
        else
          Rails.logger.debug "DEBUG: chapter does not yet exist, creating #{title} in position #{count}"
          Page.create(:title => title, :url => url, :position => count, :parent_id => self.id)
        end
        count = count.next
      end
    end
  end

  def rebuild_meta
    remove_outdated_downloads
    get_meta_from_ao3(false) if ao3?
    self.parts.map(&:rebuild_meta)
    set_wordcount
  end

  def get_meta_from_ao3(refetch=true)
    if refetch
      Rails.logger.debug "DEBUG: fetching meta from ao3 for #{self.url}"
      doc = Nokogiri::HTML(Scrub.fetch(self.url))
    else
      if parts.empty?
        Rails.logger.debug "DEBUG: build meta from raw html for #{self.id}"
        doc = Nokogiri::HTML(raw_html)
      else
        if ao3_series? && parts.first.raw_html.blank? && parts.first.parts.present?
          Rails.logger.debug "DEBUG: build meta from raw html of first part of first  part #{parts.first.parts.first.id}"
          doc = Nokogiri::HTML(parts.first.parts.first.raw_html)
        else
          Rails.logger.debug "DEBUG: build meta from raw html of first part #{parts.first.id}"
          doc = Nokogiri::HTML(parts.first.raw_html)
        end
      end
    end

    if self.ao3_chapter?  # if this is a chapter
      if position
        Rails.logger.debug "DEBUG: getting chapter title for #{self.id} at position #{position}"
        self.title = ao3_chapter_title(doc, position)
      else
        Rails.logger.debug "DEBUG: getting title for standalone single chapter #{self.id}"
        self.title = ao3_single_chapter_fic_title(doc) || ao3_doc_title(doc)
      end
    else
      if ao3_series?
        Rails.logger.debug "DEBUG: keeping title #{self.title} for #{self.id}"
      else
        Rails.logger.debug "DEBUG: getting work title for #{self.id}"
        self.title = ao3_doc_title(doc)
      end
    end

    doc_summary = Scrub.sanitize_html(doc.css(".summary blockquote")).children.to_html
    doc_notes = Scrub.sanitize_html(doc.css(".notes blockquote")).children.to_html
    doc_relationships = doc.css(".relationship a").map(&:text).join(", ")  rescue nil
    doc_tags = doc.css(".freeform a").map(&:text).join(", ")  rescue nil

    if self.ao3_chapter? && self.parent # if this is a chapter but not a deliberately single chapter
      if position == 1
        self.notes = doc_notes
      else
        self.notes = [doc_summary, doc_notes].join_hr
      end
    elsif self.parts.empty? # this is a single chapter work
      self.notes = [doc_summary, doc_notes, doc_tags, doc_relationships].join_hr
    else # this is the enclosing doc
      if self.ao3_series? && self.notes.present?
        Rails.logger.debug "DEBUG: not changing present notes for series #{self.id}"
      else
        self.notes = [doc_summary, doc_tags, doc_relationships].join_hr
      end
    end

    # don't get authors for subparts and get after notes for byline
    unless self.parent
      add_author(doc.css(".byline a").map(&:text).join(", "))
    end

    self.save
  end

#TODO
  def get_chapters_from_ff
  end

  def get_chapters_from_skyehawke
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

  def self.without_tag(string)
    query = "%#{string}%"
    where("pages.cached_tag_string NOT LIKE ?",query)
  end

  def self.with_author(string)
    joins(:authors).
    where(["authors.name LIKE ?", "%" + string + "%"])
  end

  def remove_placeholders
    self.url = self.url == "URL" ? nil : self.url.try(:strip)
    self.title = nil if self.title == "Title" unless (self.url && self.url.match('archiveofourown'))
    self.notes = nil if self.notes == "Notes"
    self.my_notes = nil if self.my_notes == "My Notes"
    self.base_url = nil if self.base_url == BASE_URL_PLACEHOLDER
    self.url_substitutions = nil if self.url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    self.urls = nil if self.urls == URLS_PLACEHOLDER
    self.read_after = Time.now if self.read_after.blank?
    self.sanitize_version = Scrub.sanitize_version
  end

  def initial_fetch
    FileUtils.rm_rf(mydirectory) # make sure directory is empty for testing
    FileUtils.mkdir_p(download_dir) # make sure directory exists
    if !self.url.blank?
      if self.ao3? && !self.url.match(/chapter/)
        self.get_meta_from_ao3
        self.get_chapters_from_ao3
        self.set_wordcount
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
      self.set_wordcount
    end
  end


end
