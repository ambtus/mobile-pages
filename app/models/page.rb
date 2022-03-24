# encoding=utf-8

class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  include Download

  def normalize_url
    return if self.url.blank?
    self.url = self.url.normalize
  end

  def convert_to_type
    return unless type.nil?
    parts.map(&:convert_to_type) unless parts.empty?
    set_type
  end

  def ao3_type
    if self.url.match(/chapters/)
      self.parent ? Chapter : Single
    elsif self.url.match(/works/)
      self.parts.size == 0 ? Single : Book
    elsif self.url.match(/series/)
      Series
    else
      Collection
    end
  end

  def initial_ao3_type
    if self.url.match(/chapters/)
      self.parent ? Chapter : Single
    elsif self.url.match(/works/)
      Book
    elsif self.url.match(/series/)
      Series
    else
      Collection
    end
  end

  def set_type
    # Rails.logger.debug "DEBUG: setting type for #{self.inspect}"
    if ao3?
      self.becomes!(self.ao3_type)
      Rails.logger.debug "DEBUG: ao3 type set to #{self.type}"
      self.type
    else
      should_be = if parts.empty?
        parent_id.nil? ? "Single" : "Chapter"
      elsif parts.map(&:type).uniq == ["Chapter"]
        Rails.logger.debug "DEBUG: part types: #{parts.map(&:type).uniq}"
        "Book"
      elsif (parts.map(&:type).uniq - ["Single", "Book"]).empty?
        Rails.logger.debug "DEBUG: part types: #{parts.map(&:type).uniq}"
        "Series"
      else
        Rails.logger.debug "DEBUG: part types: #{parts.map(&:type).uniq}"
        "Collection"
      end
      update!(type: should_be)
      Rails.logger.debug "DEBUG: non-ao3 type set to #{should_be}"
    end
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
    dups = self.authors & self.parent.authors
    self.authors.delete(dups)
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

  UNREAD = "unread"
  UNFINISHED = "unfinished"
  WIP = "WIP"
  SHORT_LENGTH = 160 # truncate at this many characters

  SIZES = ["drabble", "short", "medium", "long", "epic"]

  DRABBLE_MAX = 300
  SHORT_MAX =  3000
  MED_MAX   = 30000
  LONG_MAX = 300000

  def wip_tag; Omitted.find_or_create_by(name: WIP); end
  def wip_switch(on = false)
    if self.tags.omitted.include?(wip_tag)
      self.tags.delete(wip_tag) unless on
    else
      self.tags << wip_tag && self.cache_tags if on
    end
    return self
  end

  def set_wordcount(recount=true)
    Rails.logger.debug "DEBUG: #{self.title} old wordcount: #{self.wordcount} and size: #{self.size}"
    new_wordcout = if self.parts.size > 0
      self.parts.each {|part| part.set_wordcount } if recount
      self.parts.sum(:wordcount)
    elsif recount
      count = 0
      body = Nokogiri::HTML(self.edited_html).xpath('//body').first
      body.traverse { |node|
        if node.is_a? Nokogiri::XML::Text
          words = node.inner_text.gsub(/--/, "—").gsub(/(['’‘-])+/, "")
          count +=  words.scan(/[a-zA-Z0-9À-ÿ_]+/).size
        end
      } if body
      count
    end
    size_word = "drabble"
    if new_wordcout
      size_word = "short" if new_wordcout > DRABBLE_MAX
      size_word = "medium" if new_wordcout > SHORT_MAX
      size_word = "long" if new_wordcout > MED_MAX
      size_word = "epic" if new_wordcout > LONG_MAX
    end
    Rails.logger.debug "DEBUG: #{self.title} new wordcount: #{new_wordcout} and size: #{size_word}"
    self.update!(wordcount: new_wordcout, size: size_word)
    return self
  end

  BASE_URL_PLACEHOLDER = "Base URL: use * as replacement placeholder"
  URL_SUBSTITUTIONS_PLACEHOLDER = "replacements: space separated or range n-m"
  URLS_PLACEHOLDER = "Alternatively: full URLs for parts, one per line"
  PARENT_PLACEHOLDER = "Enter name of existing or new (unique name) parent"

  has_and_belongs_to_many :tags, -> { distinct }
  has_and_belongs_to_many :authors, -> { distinct }
  belongs_to :parent, class_name: "Page", optional: true
  belongs_to :ultimate_parent, class_name: "Page", optional: true

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls

  before_validation :remove_placeholders, :normalize_url

  validates_presence_of :title, :message => "can't be blank"
  validates_format_of :url, :with => URI.regexp, :allow_blank => true
  validates_uniqueness_of :url, :allow_blank => true

  after_create :initial_fetch

  # used in tests
  def inspect
     regexp = /([\d-]+ \d\d:\d\d)([\d:.+ ]+)/
     super.match(regexp) ? super.gsub(regexp, '\1') : super
  end
  def self.create_from_hash(hash)
    Rails.logger.debug "DEBUG: Page.create_from_hash(#{hash})"
    tag_types = Hash.new("")
    Tag.types.each {|tt| tag_types[tt] = hash.delete(tt.downcase.pluralize.to_sym) }
    ao3_fandoms = hash.delete(:ao3_fandoms)
    page = Page.create(hash)
    page.convert_to_type
    tag_types.each {|key, value| page.send("add_tags_from_string", value, key)}
    if hash[:last_read] # update read after for parts and self
      page.unread_parts.each {|p| p.update!(last_read: hash[:last_read]) && p.update_read_after}
      page.update_last_read.update_read_after
    end
    page.rate(hash[:stars]).update_read_after if hash[:stars]
    page.add_fandom(ao3_fandoms) && page.save if ao3_fandoms
    Rails.logger.debug "DEBUG: created test page #{page.inspect}"
    page
  end

  def ao3?; self.url && self.url.match(/archiveofourown/); end
  def ao3_url; self.url || self.parts.first.url.split("/chapter").first; end
  def ao3_chapter?; self.url && self.url.match(/chapters/); end

  def ff?
    (self.url && self.url.match(/fanfiction.net/)) ||
    (self.parts.first && self.parts.first.url && self.parts.first.url.match(/fanfiction.net/))
  end

  def fetch_raw
    if ff?
      self.raw_html = "edit raw html manually" if self.raw_html.blank?
      return
    end
    remove_outdated_downloads
    remove_outdated_edits
    begin
      self.raw_html = Scrub.fetch_html(self.url)
    rescue Mechanize::ResponseCodeError
      self.errors.add(:base, "error retrieving content")
    rescue SocketError
      self.errors.add(:base, "couldn't resolve host name")
    end
    return self
  end

  def parts_from_urls(url_title_list, refetch=false)
    old_part_ids = self.parts.map(&:id)
    Rails.logger.debug "DEBUG: my old parts #{old_part_ids}"

    new_part_ids = []

    lines = url_title_list.split(/[\r\n]/).select {|l| l.chomp}.map(&:squish) - [""]

    parts_with_subparts = lines.select {|l| l.match("^##")}

    if parts_with_subparts.blank?
      parts = lines.select {|l| !l.match("^#")}
    else
      parts = lines.select {|l| l.match("##")}
    end

    if parts.include?(self.url)
      self.errors.add(:url_list, "can’t include your own url")
      return false
    end

    Rails.logger.debug "DEBUG: find or create parts #{parts}"
    parts.each do |part|
      url = title = position = nil
      url = part.sub(/#.*/, "")
      title = part.sub(/.*#/, "") if part.match("#")
      position = parts.index(part) + 1
      page = if url.blank?
        Page.find_by(title: title, parent_id: self.id)
      else
        Page.find_by(url: url)
      end
      if page.blank?
        title = "Part #{position}" if title.blank?
        Rails.logger.debug "DEBUG: didn't find #{part}"
        page = Page.create(:url=>url, :title=>title, :parent_id=>self.id, :position => position)
        page.set_type
        # Rails.logger.debug "DEBUG: created #{page.reload.inspect}"
        self.update_attribute(:read_after, Time.now) if self.read_after > Time.now
        page.set_wordcount
      else
        Rails.logger.debug "DEBUG: found #{part}"
        if page.url == url
          page.fetch_raw.remove_outdated_downloads.set_wordcount if refetch
        else
          page.update!(:url, url)
          page.fetch_raw.remove_outdated_downloads.set_wordcount
        end
        page.update!(position: position) if page.position != position
        page.update!(parent_id: self.id) if page.parent_id != self.id
        page.update!(title: title) if title && page.title != title
      end
      new_part_ids << page.id
    end
    Rails.logger.debug "DEBUG: parts found or created: #{new_part_ids}"

    remove = old_part_ids - new_part_ids
    Rails.logger.debug "DEBUG: removing deleted parts #{remove}"
    remove.each do |old_part_id|
      Page.find(old_part_id).make_single
    end

    self.update_last_read.update_stars.remove_outdated_downloads.set_wordcount(false)
    self.set_type
  end

  def parts; Page.order(:position).where(["parent_id = ?", id]); end
  def unread_parts
    unreads = Page.where(["parent_id = ?", id]).where(last_read: nil)
    Rails.logger.debug "DEBUG: found #{unreads.size} unread parts"
    unreads
  end
  def read_parts
    reads = Page.where(["parent_id = ?", id]).where.not(last_read: nil)
    Rails.logger.debug "DEBUG: found #{reads.size} read parts"
    reads
  end

  def next_part
    return nil unless parent
    my_index = parent.parts.find_index(self)
    return nil if my_index.nil?
    parent.parts[my_index+1]
  end

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
      end
    end
    list.join("\n")
  end

  def make_single
    Rails.logger.debug "DEBUG: removing #{self.parent_id} from #{self.id}"
    return unless parent
    parent = self.parent
    self.tags << parent.tags - self.tags
    self.cache_tags
    self.authors << parent.authors - self.authors
    self.update_attribute(:parent_id, nil)
    self.set_type
    self.get_meta_from_ao3(false) if self.ao3?
    self.wip_switch if self.ao3_chapter?
  end

  def refetch_meta
    self.parts.each do |part|
      part.get_meta_from_ao3
    end
    self.get_meta_from_ao3
  end

  def refetch(passed_url)
    if ao3? && is_a?(Single) && !ao3_chapter?
      parent = Book.create!(title: "temp")
      self.make_me_a_chapter(parent)
      parent.update!(url: passed_url) && parent.fetch_ao3
      self.remove_duplicate_tags
    else
      update!(url: passed_url) if passed_url.present?
      Rails.logger.debug "DEBUG: refetching all for #{id} url: #{self.url}"
      if ao3?
        page = becomes!(ao3_type)
        page.fetch_ao3
      elsif ff?
        errors.add(:base, "can't refetch from fanfiction.net")
      else
        fetch_raw
      end
    end
  end

  def refetch_parts(url_list)
    Rails.logger.debug "DEBUG: refetching all for #{self.id} url_list: #{url_list}"
    self.parts_from_urls(url_list)
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
    if new # move my tags and authors to parent
      parent.tags << self.tags
      self.tags.delete(self.tags)
      parent.cache_tags
      self.cache_tags
      parent.authors << self.authors
      self.authors.delete(self.authors)
      parent.update_stars
    elsif self.unread?
      Rails.logger.debug "DEBUG: updating parent last read"
      parent.update_last_read
    end
    self.update!(type: "Chapter") if self.type == "Single"
    parent.set_wordcount(false)
    parent.set_type
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
    Rails.logger.debug "DEBUG: making #{title} unfinished"
    self.update!(stars: 9, last_read: nil, read_after: Date.today + 5.years)
    return self
  end

  def read_today
    self.update!(last_read: Time.now)
    parent.update_last_read if parent
    return self
  end

  def rate(stars)
    self.update!(stars: stars)
    parts.each{|p| p.update!(stars: stars) && p.update_read_after} if parts.any?
    return self
  end

  def rate_unread(stars)
    Rails.logger.debug "DEBUG: stars for unread: #{stars}"
    self.unread_parts.each do |part|
      Rails.logger.debug "DEBUG: updating #{part.title} with stars: #{stars}"
      part.update!(last_read: Time.now, stars: stars)
    end
    return self
  end

  def update_last_read
    return self unless parts.any?
    last_reads = self.parts.map(&:last_read)
    if last_reads.include?(nil)
      self.update!(last_read: nil)
      Rails.logger.debug "DEBUG: unsetting last_read for #{self.title}"
    else
      self.update!(last_read: last_reads.sort.first)
      Rails.logger.debug "DEBUG: new last read: #{self.last_read}"
    end
    return self
  end

  def update_stars
    return self unless parts.any?
    mode = parts.map(&:stars).compact.mode
    highest = parts.map(&:stars).sort.last
    Rails.logger.debug "DEBUG: mode: #{mode}, highest: #{highest}"
    if mode
      self.update!(stars: mode)
    else
      self.update!(stars: highest)
    end
    Rails.logger.debug "DEBUG: new stars: #{self.stars}"
    return self
  end

  def update_read_after
    return self if stars == 9
    if last_read
      Rails.logger.debug "DEBUG: last read: #{self.last_read.to_date}"
      new_read_after = case stars
        when 5
          last_read + 6.months
        when 4
          last_read + 1.year
        when 3
          last_read + 2.years
        when 2
          last_read + 3.years
        when 1
          last_read + 4.years
      end
    else
      Rails.logger.debug "DEBUG: created at: #{self.created_at.to_date}"
      new_read_after = created_at
    end
    self.update!(read_after: new_read_after)
    Rails.logger.debug "DEBUG: new read after: #{self.read_after}"
    return self
  end

  def cleanup(recount = true); update_last_read.update_stars.update_read_after.remove_outdated_downloads.set_wordcount(recount); end

  def add_author_string=(string)
    return if string.blank?
    string.split(",").each do |possible|
      author = Author.find_by_short_name(possible)
      author = Author.find_or_create_by(name: possible.squish) unless author
      self.authors << author unless self.authors.include?(author)
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
  def size_string; "#{ActionController::Base.helpers.number_with_delimiter(self.wordcount)} words"; end
  def last_read_string
    if unread?
      if parts.any?
        if parts.map(&:last_read).any?
          last_part_read = parts.map(&:last_read).compact.map(&:to_date).sort.first
          "#{UNREAD} parts (#{last_part_read})"
        elsif parts.map(&:parts).any?
          subparts = parts.map(&:parts).flatten
          if subparts.map(&:last_read).any?
            last_subpart_read = subparts.map(&:last_read).compact.map(&:to_date).sort.first
            Rails.logger.debug "DEBUG: last_subpart_read: #{last_subpart_read}"
            "#{UNREAD} subparts (#{last_subpart_read})"
          else
            unread_string
          end
        else
          unread_string
        end
      else
        unread_string
      end
    else
      last_read.to_date
    end
  end
  def my_formatted_notes; Scrub.sanitize_html(my_notes); end
  def formatted_notes; Scrub.sanitize_html(notes); end

  # used in index view and in epub comments
  def short_notes; RubyPants.new(Scrub.sanitize_and_strip(notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end
  def my_short_notes; RubyPants.new(Scrub.sanitize_and_strip(my_notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end

  def add_tags_from_string(string, type="Tag")
    return if string.blank?
    type = "Tag" if type == "Trope"
    string.split(",").each do |tag|
      typed_tag = type.constantize.find_or_create_by(name: tag.squish)
      self.tags << typed_tag unless self.tags.include?(typed_tag)
    end
    self.cache_tags
  end

  def cache_string; self.tags.not_hidden.joined; end
  def cache_tags
    Rails.logger.debug "DEBUG: cache_tags for #{self.id} tags: #{cache_string}, hiddens: #{hidden_string}"
    self.remove_outdated_downloads
    self.update(cached_tag_string: cache_string, cached_hidden_string: hidden_string)
    self
  end

  def unfinished?; stars == 9; end
  def unrated?; stars == 10; end
  def stars?; [5,4,3,2,1].include?(self.stars); end
  def star_string
    if stars?
      "#{stars} " + "stars".pluralize(stars)
    elsif unfinished?
      UNFINISHED
    elsif unrated?
      nil
    else
      Rails.logger.debug "DEBUG: stars are #{self.stars}, should be 5,4,3,2,1,9,or 10"
      "unknown"
    end
  end

  def title_prefix; title.match(position.to_s) ? "" : "#{position}. "; end

  def unread_string
    if unfinished?
      UNFINISHED
    elsif unread?
      UNREAD
    else
      ""
    end
  end

  def meta_strings; [author_string, last_read_string, star_string, size_string, *tags.by_type.by_name.map(&:name)].uniq.reject(&:blank?); end
  def title_suffix; meta_strings.empty? ? "" : " (#{meta_strings.join_comma})"; end

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

  def remove_outdated_edits
    return self unless self.id
    FileUtils.rm_f(self.scrubbed_html_file_name)
    FileUtils.rm_f(self.edited_html_file_name)
    self
  end

  def add_author(string)
    return if string.blank?
    tries = string.split(", ")
    mp_authors = []
    non_mp_authors = []
    tries.each do |t|
      try = t.split(" (").first
      Rails.logger.debug "DEBUG: trying #{try}"
      found = Author.where('name like ?', "%#{try}%").first
      if found.blank?
        non_mp_authors << t
      else
        Rails.logger.debug "DEBUG: found #{found.name}"
        if self.authors.include?(found) || (self.parent && self.parent.authors.include?(found))
          Rails.logger.debug "DEBUG: won't add #{found.name} to authors"
        else
          Rails.logger.debug "DEBUG: will add #{found.name} to authors"
          mp_authors << found
        end
      end
    end
    unless mp_authors.empty?
      Rails.logger.debug "DEBUG: adding #{mp_authors.map(&:name)} to authors"
      mp_authors.each {|a| self.authors << a}
    end
    unless non_mp_authors.empty?
      Rails.logger.debug "DEBUG: adding #{non_mp_authors} to notes"
      byline = "by #{non_mp_authors.join(", ")}"
      self.notes = "<p>#{byline}</p>#{self.notes}"
    end
  end

  def add_fandom(string)
    return if string.blank?
    tries = string.split(", ")
    mp_fandoms = []
    non_mp_fandoms = []
    tries.each do |t|
      try = t.split(" | ").last.split(" - ").first.split(":").first.split('(').first
      simple = try ? try.strip : t.split(" | ").last
      simple.sub!(/^The /, '')
      simple = I18n.transliterate(simple).delete('?')
      Rails.logger.debug "DEBUG: trying #{simple}"
      found = Fandom.where('name like ?', "%#{simple}%").first
      if found.blank? && simple.present?
        trying = simple.split(/[ -]/)
        Rails.logger.debug "DEBUG: trying #{trying}"
        possibles = trying.collect{|w| Fandom.where('name like ?', "%#{w}%") if w.length > 3}.flatten.compact
        Rails.logger.debug "DEBUG: possible tags are #{possibles.map(&:name)}"
        maybes = possibles.collect{|t| t unless trying.select{|w| t.name.match /\b#{w}\b/ }.empty?}
        Rails.logger.debug "DEBUG: maybe tags are #{maybes.compact.map(&:name)}"
        found = maybes.compact.mode
      end
      if found.blank?
        non_mp_fandoms << simple if simple.present?
      else
        Rails.logger.debug "DEBUG: found #{found.name}"
        Rails.logger.debug "DEBUG: #{self.parent.tags.map(&:name)}" if self.parent
        if self.tags.include?(found)
          Rails.logger.debug "DEBUG: won't re-add #{found.name} to tags"
        elsif self.parent && self.parent.tags.include?(found)
          Rails.logger.debug "DEBUG: won't duplicate parents #{found.name} in my tags"
        else
          Rails.logger.debug "DEBUG: will add #{found.name} to tags"
          mp_fandoms << found
        end
      end
    end
    unless mp_fandoms.empty?
      Rails.logger.debug "DEBUG: adding #{mp_fandoms.uniq.map(&:name)} to fandoms"
      mp_fandoms.uniq.each {|f| self.tags << f}
    end
    unless non_mp_fandoms.empty?
      fandoms = non_mp_fandoms.uniq
      Rails.logger.debug "DEBUG: adding #{fandoms} to notes"
      suffix = fandoms.size == 1 ? "" : "s"
      self.notes = "<p>Fandom#{suffix}: #{fandoms.join(", ")}</p>#{self.notes}"
    end
  end

  def rebuild_meta
    # Rails.logger.debug "DEBUG: rebuilding meta for #{self.inspect}"
    remove_outdated_downloads
    if ao3?
      page = self.becomes!(self.ao3_type)
      # Rails.logger.debug "DEBUG: page is #{page.inspect}"
      page.get_meta_from_ao3(false)
    elsif parts.any?
      self.get_meta_from_ao3(false) if parts.first.ao3_chapter?
    else
      set_type
    end
    Rails.logger.debug "DEBUG: type is #{self.type}"
    self.parts.map(&:rebuild_meta)
    set_wordcount
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

  def remove_placeholders
    self.url = self.url == "URL" ? nil : self.url.try(:strip)
    self.notes = nil if self.notes == "Notes"
    self.my_notes = nil if self.my_notes == "My Notes"
    self.base_url = nil if self.base_url == BASE_URL_PLACEHOLDER
    self.url_substitutions = nil if self.url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    self.urls = nil if self.urls == URLS_PLACEHOLDER
    self.read_after = Time.now if self.read_after.blank?
    self.sanitize_version = Scrub.sanitize_version
  end

  def initial_fetch
    # Rails.logger.debug "DEBUG: initial fetch for #{self.inspect}"
   Rails.logger.debug "DEBUG: initial fetch for #{self.title} (id: #{self.id})"
   FileUtils.rm_rf(mydirectory) # make sure directory is empty for testing
    FileUtils.mkdir_p(download_dir) # make sure directory exists

    if !self.url.blank?
      if self.ao3?
        if type.nil?
          page = self.becomes!(self.initial_ao3_type)
          Rails.logger.debug "DEBUG: page became #{page.type}"
        else
          page = self
        end
        page.fetch_ao3
      else
        self.fetch_raw
      end
    elsif !self.base_url.blank?
      page = self.becomes!(Book)
      Rails.logger.debug "DEBUG: page became #{page.type}"
      count = 1
      match = url_substitutions.match("-")
      if match
        array = match.pre_match.to_i .. match.post_match.to_i
      else
        array = url_substitutions.split
      end
      array.each do |sub|
        title = "Part " + count.to_s
        url = base_url.gsub(/\*/, sub.to_s)
        Chapter.create(:title => title, :url => url, :position => count, :parent_id => page.id)
        count = count.next
      end
      page.set_wordcount
    elsif !self.urls.blank?
      self.parts_from_urls(self.urls)
    else
      self.set_wordcount
    end
  end


end
