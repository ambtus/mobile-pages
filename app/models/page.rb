# encoding=utf-8

class Page < ActiveRecord::Base
  MODULO = 300  # files in a single directory
  include Download

  LIMIT = 5 # number of parts to show at a time

  def normalize_url
    return if self.url.blank?
    if self.url.match("archiveofourown.org/users")
      self.errors.add(:url, "cannot be ao3 user")
      return false
    elsif self.url.match("(.*)/collections/(.*)/works/(.*)")
      self.url = $1 + "/works/" + $3
    elsif self.url.match("archiveofourown.org/collections")
      self.errors.add(:url, "cannot be an ao3 collection")
      return false
    end
    self.url = self.url.normalize
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
    #Rails.logger.debug "DEBUG: setting type for #{self.inspect}"
    if ao3?
      page = self.becomes(self.ao3_type)
      Rails.logger.debug "DEBUG: ao3 type set to #{page.type}"
      self.update_columns type: page.type
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
      Rails.logger.debug "DEBUG: non-ao3 type set to #{should_be}"
      self.update_columns type: should_be
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
  UNREAD_PARTS_DATE = Date.new(1967) # year first fanzine published. couldn't have read before that ;)
  UNFINISHED = "unfinished"
  WIP = "WIP"
  TT = "Time Travel"
  OTHER = "Other Fandom"
  SHORT_LENGTH = 160 # truncate at this many characters
  MEDIUM_LENGTH = 480

  SIZES = ["drabble", "short", "medium", "long", "epic"]

  DRABBLE_MAX = 300
  SHORT_MAX =  3000
  MED_MAX   = 30000
  LONG_MAX = 300000

  def wip_tag; Con.find_or_create_by(name: WIP); end
  def wip_switch(on = false)
    if self.tags.cons.include?(wip_tag)
      self.tags.delete(wip_tag) unless on
    else
      self.tags << wip_tag if on
    end
    return self
  end

  def set_hidden; update_columns hidden: true; end
  def unset_hidden; update_columns hidden: false; end
  def reset_hidden;
    self.tags.hiddens.present? ? set_hidden : unset_hidden
  end

  def other_fandom_tag; Fandom.find_or_create_by(name: OTHER); end
  def other_fandom_present?; self.tags.fandoms.include?(other_fandom_tag);end
  def toggle_other_fandom
    if other_fandom_present?
      self.tags.delete(other_fandom_tag)
    else
      self.tags << other_fandom_tag
    end
    return self
  end

  def tt_tag; Pro.find_or_create_by(name: TT); end
  def tt_present?; self.tags.pros.include?(tt_tag);end
  def toggle_tt
    if tt_present?
      self.tags.delete(tt_tag)
    else
      self.tags << tt_tag
    end
    return self
  end
  def ao3_tt(strings)
    found = []
    strings.each do |string|
      if string.match("Time Travel")
        self.tags << tt_tag
        return self
      end
    end
    return self
  end


  def set_wordcount(recount=true)
    Rails.logger.debug "DEBUG: #{self.title} old wordcount: #{self.wordcount} and size: #{self.size}"
    new_wordcout = if self.parts.size > 0
      self.parts.each {|part| part.set_wordcount } if recount
      self.parts.sum(:wordcount)
    elsif recount && !self.is_a?(Series)
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
    self.update_columns wordcount: new_wordcout, size: size_word
    return self
  end

  BASE_URL_PLACEHOLDER = "Base URL: use * as replacement placeholder"
  URL_SUBSTITUTIONS_PLACEHOLDER = "replacements: space separated or range n-m"
  URLS_PLACEHOLDER = "Alternatively: full URLs for parts, one per line"
  PARENT_PLACEHOLDER = "Enter name of existing or new (unique name) parent"

  has_and_belongs_to_many :tags, -> { distinct }
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
    tag_types.compact.each {|key, value| page.send("add_tags_from_string", value, key)}
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
      Rails.logger.debug "DEBUG: fetching raw html from #{self.url}"
      self.raw_html = Scrub.fetch_html(self.url)
    rescue Mechanize::ResponseCodeError
      Rails.logger.debug "DEBUG: content unavailable"
      self.errors.add(:base, "error retrieving content")
    rescue SocketError
      Rails.logger.debug "DEBUG: host unavailable"
      self.errors.add(:base, "couldn't resolve host name")
    end
    return self
  end

  def add_part(part_url)
    position = parts.last.position + 1
    page = Page.find_by(url: part_url)
    if page.blank?
      title = "Part #{position}"
      page = Page.create(:url=>part_url, :title=>title, :parent_id=>self.id, :position => position)
      page.set_type
      # Rails.logger.debug "DEBUG: created #{page.reload.inspect}"
      self.update_attribute(:read_after, Time.now) if self.read_after > Time.now
      page.set_wordcount
    else
      Rails.logger.debug "DEBUG: found #{part}"
      page.update!(position: position) if page.position != position
      page.update!(parent_id: self.id) if page.parent_id != self.id
    end
    self.cleanup(false)
    self.parent.cleanup(false) if parent
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
        elsif url.present?
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
    unreads = parts.where(:last_read => [nil, UNREAD_PARTS_DATE])
    Rails.logger.debug "DEBUG: found #{unreads.size} unread parts"
    unreads
  end
  def read_parts
    reads = parts.where.not(:last_read => [nil, UNREAD_PARTS_DATE])
    Rails.logger.debug "DEBUG: found #{reads.size} read parts"
    reads
  end

  def next_part
    return nil unless parent
    my_index = parent.parts.find_index(self)
    return nil if my_index.nil?
    parent.parts[my_index+1]
  end

  def not_hidden_parts; parts.where(hidden: false); end

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
    Rails.logger.debug "DEBUG: removing #{self.id} from #{self.parent_id}"
    return unless parent
    parent = self.parent
    self.tags << parent.tags - self.tags
    self.update(parent_id: nil, position: nil)
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
      me = Chapter.find(self.id).get_meta_from_ao3(false)
      me.remove_duplicate_tags
    else
      update!(url: passed_url) if passed_url.present?
      Rails.logger.debug "DEBUG: refetching all for #{id} url: #{self.url}"
      if ao3?
        page = becomes!(ao3_type)
        page.fetch_ao3
      elsif ff?
        errors.add(:base, "can't refetch from fanfiction.net")
      else
        fetch_raw.remove_outdated_downloads.set_wordcount
        self.parent.set_wordcount(false) if self.parent
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
    if new
      Rails.logger.debug "DEBUG: moving tags to parent"
      parent.tags << self.tags
      if self.hidden?
        Rails.logger.debug "DEBUG: moving hidden state to parent"
        self.unset_hidden
        parent.set_hidden
      end
      parent.update_stars
    end
    self.remove_duplicate_tags
    Rails.logger.debug "DEBUG: updating parent last read"
    parent.update_last_read
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
    if last_reads.compact.empty?
      self.update!(last_read: nil)
    elsif last_reads.include?(nil)
      self.update!(last_read: UNREAD_PARTS_DATE)
    else
      self.update!(last_read: last_reads.sort.first)
    end
    #Rails.logger.debug "DEBUG: new last read: #{self.last_read}"
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
    #Rails.logger.debug "DEBUG: new stars: #{self.stars}"
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

  def cleanup(recount = true)
    update_last_read.update_stars.remove_outdated_downloads.set_wordcount(recount)
  end

  def unread?; last_read.blank?; end
  def read?
     answer = last_read.present? && last_read != UNREAD_PARTS_DATE
     #Rails.logger.debug "DEBUG: read? #{last_read} #{answer}"
     return answer
  end
  def unread_parts?
     answer = last_read == UNREAD_PARTS_DATE
     #Rails.logger.debug "DEBUG: unread_parts? #{last_read} #{answer}"
     return answer
  end

  def parts_string
    suffix = parts.size == 1 ? "" : "s"
    parts.blank? ? "" : " (#{parts.size} part#{suffix})"
  end
  def size_string
     "#{ActionController::Base.helpers.number_with_delimiter(self.wordcount)} words" + parts_string
  end

  def last_read_string
    if read?
      #Rails.logger.debug "DEBUG: last read #{last_read.to_date}"
      last_read.to_date
    elsif unread_parts?
      suffix = unread_parts.size == 1 ? "" : "s"
      initial_string = "#{unread_parts.size} #{UNREAD} part#{suffix}"
      unless read_parts.empty?
        #Rails.logger.debug "DEBUG: read parts"
        read_dates = read_parts.map(&:last_read)
      else
        #Rails.logger.debug "DEBUG: no read parts, searching subparts"
        subparts = parts.map(&:parts).flatten
        read_dates = subparts.map(&:last_read).compact
        read_dates.delete(UNREAD_PARTS_DATE)
      end
      if read_dates.empty?
        #Rails.logger.debug "DEBUG: all parts & subparts last read never"
        initial_string
      else
        #Rails.logger.debug "DEBUG: last read dates: #{read_dates}"
        initial_string + " (#{read_dates.sort.first.to_date})"
      end
    elsif unread?
      #Rails.logger.debug "DEBUG: last read never"
      unread_string
    end
  end
  def my_formatted_notes; Scrub.sanitize_html(my_notes); end
  def formatted_notes; Scrub.sanitize_html(notes); end

  # used in show view
  def medium_notes
    return "" if notes.blank?
    Scrub.sanitize_html(notes.truncate(MEDIUM_LENGTH, separator: /\s/)).html_safe
  end

  # used in index view and in epub comments
  # RubyPants turns quotes into smart quotes which don't mess up the epub command
  def short_notes; RubyPants.new(Scrub.sanitize_and_strip(notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end
  def my_short_notes; RubyPants.new(Scrub.sanitize_and_strip(my_notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end

  def add_tags_from_string(string, type="Tag")
    return if string.blank?
    type = "Tag" if type == "Trope"
    Rails.logger.debug "DEBUG: adding #{type} #{string}"
    self.set_hidden if type == "Hidden"
    string.split(",").each do |tag|
      typed_tag = type.constantize.find_by_short_name(tag.squish)
      typed_tag = type.constantize.find_or_create_by(name: tag.squish) unless typed_tag
      self.tags << typed_tag unless self.tags.include?(typed_tag)
    end
    Rails.logger.debug "DEBUG: tags now #{self.tags.joined}"
  end

  def unfinished?; stars == 9; end
  def unrated?; stars == 10; end
  def stars?; [5,4,3,2,1].include?(self.stars); end
  def star_string
    if stars?
      "#{stars} " + "star".pluralize(stars)
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

  def ordered_tag_names
    result = []
    Tag.types.each do |type|
      result << self.tags.send(type.downcase.pluralize).by_name
    end
    result.flatten.map(&:base_name)
  end

  # used in page index
  def meta_string; [*ordered_tag_names, star_string, last_read_string, size_string, ].uniq.reject(&:blank?).join_comma; end
  # used in page show
  def title_suffix; meta_string.blank? ? "" : " (#{meta_string})"; end

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
    return self
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
    return self
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

  ### epub html is what I use for conversion
  ### ebook-convert silently drops all http images, so might as well try https
  ### even if https doesn't exist, I'm no worse off than before

  def epub_html
    edited_html.gsub('img src="http://', 'img src="https://')
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
    audio_tag = Tag.find_by(name: "audio") || Info.create(name: "audio")
    self.tags << audio_tag
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
    existing = []
    non_existing = []
    singles = string.split(", ")
    singles.each do |single|
      found = nil
      possibles = single.gsub("(", ",").gsub(")", "").split(",")
      possibles.each do |try|
        Rails.logger.debug "DEBUG: trying '#{try}'"
        found = Author.find_by_short_name(try.strip)
        if found
          Rails.logger.debug "DEBUG: found #{try}"
          existing << found
          break
        end
      end
      non_existing << single unless found
    end
    unless existing.empty?
      Rails.logger.debug "DEBUG: adding #{existing.map(&:name)} to authors"
      existing.uniq.each {|a| self.tags << a unless self.all_authors.include?(a)}
    end
    unless non_existing.empty?
      tagged_authors = self.tags.authors + (self.parent ? self.parent.tags.authors : [])
      by = tagged_authors.empty? ? "by" : "et al:"
      Rails.logger.debug "DEBUG: adding #{non_existing} to notes"
      self.update notes: "<p>#{by} #{non_existing.join(", ")}</p>#{self.notes}"
    end
    return self
  end

  def add_fandom(string)
    return if string.blank?
    tries = string.split(", ")
    existing = []
    non_existing = []
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
        non_existing << simple if simple.present?
      else
        Rails.logger.debug "DEBUG: found #{found.name}"
        if self.tags.include?(found)
          Rails.logger.debug "DEBUG: won't re-add #{found.name} to tags"
        elsif self.parent && self.parent.tags.include?(found)
          Rails.logger.debug "DEBUG: won't duplicate parent's #{found.name} in my tags"
        elsif self.other_fandom_present? # use other fandom tag to prevent false positives
           Rails.logger.debug "DEBUG: will NOT add #{found.name} to tags: add to notes instead"
           non_existing << simple if simple.present?
        else
          Rails.logger.debug "DEBUG: will add #{found.name} to tags"
          existing << found
        end
      end
    end
    if existing.empty?
      if self.tags.fandoms.blank? && self.parent.blank?
        Rails.logger.debug "DEBUG: adding #{OTHER} to fandoms"
        self.tags << other_fandom_tag
      end
    else
      Rails.logger.debug "DEBUG: adding #{existing.uniq.map(&:name)} to fandoms"
      existing.uniq.each {|f| self.tags << f}
    end
    unless non_existing.empty?
      fandoms = non_existing.uniq
      Rails.logger.debug "DEBUG: adding #{fandoms} to notes"
      self.update notes: "<p>#{fandoms.join(", ")}</p>#{self.notes}"
    end
    return self
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
    if self.title.blank? && self.url.blank?
      self.errors.add(:base, "Both URL")
      return false
    end
    self.title = "no title provided" if self.title.blank?
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
      count = 1
      match = url_substitutions.match("-")
      if match
        array = match.pre_match.to_i .. match.post_match.to_i
      else
        array = url_substitutions.split
      end
      self.type = "Book"
      self.save!
      array.each do |sub|
        title = "Part " + count.to_s
        url = base_url.gsub(/\*/, sub.to_s)
        Chapter.create(:title => title, :url => url, :position => count, :parent_id => self.id)
        count = count.next
      end
      self.set_wordcount
    elsif !self.urls.blank?
      self.parts_from_urls(self.urls)
    else
      self.set_wordcount
    end
    self.set_type unless self.type
  end


end
