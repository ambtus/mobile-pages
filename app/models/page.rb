# encoding=utf-8

class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory

  def self.remove_all_downloads
    self.all.each do |page|
      page.remove_outdated_downloads
    end;1
  end

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
      Rails.public_path.to_s + mypath
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

  DURATION = "years"
  UNREAD = "unread"
  SHORT_LENGTH = 80 # truncate at this many characters
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
    %w{tags hiddens fandoms}.each {|tag_type| tag_types[tag_type] = hash.delete(tag_type.to_sym) }
    page = Page.create(hash)
    tag_types.each do |key, value|
      page.send("add_#{key}_from_string", value)
    end
    Rails.logger.debug "DEBUG: created page with tags: [#{page.tags.joined}]"
    page
  end

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
    pages = Page.all
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
    [:title, :notes, :my_notes].each do |attrib|
      pages = pages.search(attrib, params[attrib]) if params.has_key?(attrib)
    end
    if params.has_key?(:url) # strip the https? in case it was stored under the other
      pages = pages.search(:url, params[:url].sub(/^https?/, ''))
    end
    pages = pages.search(:cached_tag_string, params[:tag]) if params.has_key?(:tag)
    pages = pages.search(:cached_tag_string, params[:fandom]) if params.has_key?(:fandom)
    if params.has_key?(:hidden)
      pages = pages.search(:cached_hidden_string, params[:hidden])
    else
      pages = pages.where(:cached_hidden_string => "")
    end
    pages = pages.with_author(params[:author]) if params.has_key?(:author)
    # can only find parts by title, notes, my_notes, url, last_created.
    unless params[:title] || params[:notes] || params[:my_notes] || params[:url] ||
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
  def ao3_chapter?; self.url.match(/chapters/); end


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

  def part_title(position, original)
    if original
      if original.match(position)
        original
      else
        "#{position}. #{original}"
      end
    else
      "Part #{position}"
    end
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
      original_title = part.sub(/.*#/, "") if part.match("#")
      position = parts.index(part) + 1
      title = part_title(position.to_s, original_title)
      page = Page.find_by(url: url) unless url.blank?
      page = Page.find_by(title: title, parent_id: parent.id) unless page
      page = Page.find_by(title: original_title, parent_id: parent.id) unless page
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
      original_title = subpart.sub(/.*#/, "") if subpart.match("#")
      title = part_title(position.to_s, original_title)
      page = if url.blank?
        part.parts.find {|p| p.title.match(original_title) }
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
    self.set_wordcount
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
      parent.tags << self.tags.not_hidden
      parent.cache_tags
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
    self.favorite = interesting + nice
    update_read_after
    self.parent.update_rating(interesting_string, nice_string, false, true) if self.parent && update_parent
    self.parts.each {|p| p.update_rating(interesting_string, nice_string, true, false)} if update_children
    return self.favorite
  end

  def update_read_after
    rating = self.favorite
    if rating == 0
      self.read_after = Time.now + 6.months
    else
      self.read_after = Time.now + rating.send(DURATION)
    end
    self.save
  end


  def add_author_string=(string)
    return if string.blank?
    string.split(",").each do |author|
      new = Author.find_or_create_by(name: author.squish)
      self.authors << new
    end
    self.authors
  end

  def unread?; last_read.blank?; end

  # used in show view
  def generic_string; self.tags.generic.by_name.joined; end
  def fandom_string; self.tags.fandom.by_name.joined; end
  def hidden_string; self.tags.hidden.by_name.joined; end
  def author_string; self.authors.joined; end
  def favorite_string; self.favorite_names.join(", "); end
  def size_string; "#{self.size} (#{self.wordcount})"; end
  def last_read_string; unread? ? UNREAD : last_read.to_date; end
  def my_formatted_notes; Scrub.sanitize_html(my_notes); end
  def formatted_notes; Scrub.sanitize_html(notes); end
  def part_tag_string; tags_et_al.empty? ? "" : " (#{tags_et_al.join(', ')})"; end

  # used in index view
  def merged_tag_string; tags_et_al.join(', ');end
  def short_notes; Scrub.strip_html(notes).truncate(SHORT_LENGTH, separator: /\s/); end
  def my_short_notes; Scrub.strip_html(my_notes).truncate(SHORT_LENGTH, separator: /\s/); end

  def add_tags_from_string(string)
    return if string.blank?
    string.split(",").each do |tag|
      self.tags << Tag.find_or_create_by(name: tag.squish)
    end
    self.save!
    self.cache_tags
  end

  def add_hiddens_from_string(string)
    return if string.blank?
    string.split(",").each do |tag|
      self.tags << Hidden.find_or_create_by(name: tag.squish)
    end
    self.cache_tags
  end

  def add_fandoms_from_string(string)
    return if string.blank?
    string.split(",").each do |tag|
      self.tags << Fandom.find_or_create_by(name: tag.squish)
    end
    self.cache_tags
  end

  def cache_string; self.tags.not_hidden.ordered.joined; end
  def cache_tags
    Rails.logger.debug "DEBUG: cache_tags for #{self.id} tags: #{cache_string}, hiddens: #{hidden_string}"
    self.update(cached_tag_string: cache_string, cached_hidden_string: hidden_string)
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

  def et_al_names
    [
      (self.authors.empty? ? nil : "by #{author_string}"),
      self.size,
      *self.favorite_names,
      (self.last_read.blank? ? "unread" : self.last_read.to_date),
    ].compact
  end

  def tags_et_al_names; et_al_names + tags.ordered.map(&:name); end
  def tags_et_al
    mine = self.tags_et_al_names
    if self.parent
      mine = mine - self.parent.tags_et_al_names
    end
    mine
  end

  def title_with_tags; title + part_tag_string; end


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
  def hidden?; cached_hidden_string.present?; end
  def download_author_string; hidden? ? "" : authors.map(&:short_name).join(" & "); end
  ## --tags
  ## if it's hidden, then the hidden tags are the only tags
  ## if it's not hidden, then add size and unread (if not read) to not-fandom tags
  def download_tags;
    [(unread? ? UNREAD : ""),
     size,
     tags.not_fandom.joined,
     ].join_comma
  end
  def download_tag_string; hidden? ? cached_hidden_string : download_tags; end
  ## --series
  ## if it's a crossover, then replace the fandom tags
  def crossover?; tags.fandom.size > 1; end
  def fandom_name; tags.fandom.present? ? tags.fandom.first.name : ""; end
  def download_fandom_string; crossover? ? "crossover" : fandom_name; end
  ## --comments
  ## if it's hidden, then put the authors into the comments
  def download_comment_string
    [
      (hidden? ? "by #{author_string}, #{hidden_string}" : ""),
      fandom_string,
      generic_string,
      favorite_string,
      size_string,
      my_short_notes,
      short_notes,
    ].join_comma.truncate(SHORT_LENGTH, separator: /\s/)
  end

  def epub_tags
    string = ""
    unless self.download_author_string.blank?
      string = string + %Q{ --authors "#{self.download_author_string}"}
    end
    unless self.download_tag_string.blank?
      string = string + %Q{ --tags "#{self.download_tag_string}"}
    end
    unless self.download_fandom_string.blank?
      string = string + %Q{ --series "#{self.download_fandom_string}"}
    end
    unless self.download_comment_string.blank?
      string = string + %Q{ --comments "#{self.download_comment_string}"}
    end
    string
  end
  def epub_command
     cmd = %Q{cd "#{self.download_dir}"; ebook-convert "#{self.download_basename}.html" "#{self.download_basename}.epub" --title "#{self.title}"} + epub_tags
    # Rails.logger.debug "DEBUG: #{cmd}"
    Rails.logger.debug "DEBUG: #{epub_tags}"
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
      self.notes = self.notes ? [byline,notes].join("\n\n") : byline
      self.update_attribute(:notes, self.notes) unless self.new_record?
      self.notes
    end
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
      original = chapter_title.gsub(/^: /,"")
      if original.match(position.to_s)
        original
      else
        "#{position}. #{original}"
      end
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
        Rails.logger.debug "DEBUG: build meta from raw html of first part #{parts.first.id}"
        doc = Nokogiri::HTML(parts.first.raw_html)
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
      Rails.logger.debug "DEBUG: getting work title for #{self.id}"
      self.title = ao3_doc_title(doc)
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
      self.notes = [doc_summary, doc_tags, doc_relationships].join_hr
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
    where(["authors.name LIKE ?", string + "%"])
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
