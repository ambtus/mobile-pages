# encoding=utf-8

class Page < ActiveRecord::Base
  include Download
  include Meta
  include Rate
  include Utilities
  include Nodes
  include Soon
  include Split

  scope :reading, -> { where(soon: -1) }
  scope :soonest, -> { where(soon: 0) }
  scope :not_hidden, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }
  scope :random, -> { order(Arel.sql('RAND()')) }
  scope :recent, -> { order('updated_at desc') }

  MODULO = 1000  # files in a single directory
  LIMIT = 5 # number of parts to show at a time

  def normalize_url
    return if self.url.blank?
    normalized = self.url.normalize
    if normalized.blank?
      self.errors.add(:url, "is invalid")
      return false
    elsif normalized.match("archiveofourown.org/users")
      self.errors.add(:url, "cannot be ao3 user")
      return false
    elsif normalized.match("(.*)/collections/(.*)/works/(.*)")
      normalized = $1 + "/works/" + $3
    elsif normalized.match("archiveofourown.org/collections")
      self.errors.add(:url, "cannot be an ao3 collection")
      return false
    end
    self.url = normalized
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
    #Rails.logger.debug "setting type for #{self.inspect}"
    if ao3?
      Rails.logger.debug "ao3 type set to #{self.ao3_type}"
      self.update!(type: ao3_type)
    else
      should_be =
        if parts.empty?
          parent_id.nil? ? Single : Chapter
        else
          part_types = parts.map(&:type).uniq.compact
          Rails.logger.debug "part types: #{part_types}"
          if (part_types - ["Chapter"]).empty?
            Book
          elsif (part_types - ["Single", "Book"]).empty?
            Series
          else
            Collection
          end
        end
      Rails.logger.debug "non-ao3 type set to #{should_be} for #{self.title}"
      self.update!(type: should_be)
    end
    parent.set_type if parent
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

  SHORT_LENGTH = 160 # truncate at this many characters
  MEDIUM_LENGTH = 480

  SIZES = ["drabble", "short", "medium", "long", "epic"]

  DRABBLE_MAX = 300
  SHORT_MAX =  3000
  MED_MAX   = 30000
  LONG_MAX = 300000

  def set_hidden; update_columns hidden: true; end
  def unset_hidden; update_columns hidden: false; end
  def reset_hidden; self.tags.hiddens.present? ? set_hidden : unset_hidden; end

  def set_con; update_columns con: true; end
  def unset_con; update_columns con: false; end
  def reset_con; self.tags.cons.present? ? set_con : unset_con; end

  def set_pro; update_columns pro: true; end
  def unset_pro; update_columns pro: false; end
  def reset_pro; self.tags.pros.present? ? set_pro : unset_pro; end

  def set_wordcount(recount=true)
    #Rails.logger.debug "#{self.title} old wordcount: #{self.wordcount} and size: #{self.size}"
    new_wordcount = if self.parts.size > 0
        Rails.logger.debug "getting wordcount for #{self.title} from parts"
        self.parts.each {|part| part.set_wordcount } if recount
        self.parts.sum(:wordcount)
      elsif recount && self.has_content?
        Rails.logger.debug "getting wordcount for #{self.title} by recounting"
        count = 0
        body = Nokogiri::HTML(self.edited_html).xpath('//body').first
        body.traverse { |node|
          if node.is_a? Nokogiri::XML::Text
            words = node.inner_text.gsub(/--/, "—").gsub(/(['’‘-])+/, "")
            count +=  words.scan(/[a-zA-Z0-9À-ÿ_]+/).size
          end
        } if body
        count
      else
        Rails.logger.debug "getting wordcount for #{self.title} from previous count"
        wordcount || 0
    end
    size_word = "drabble"
    if new_wordcount
      size_word = "short" if new_wordcount > DRABBLE_MAX
      size_word = "medium" if new_wordcount > SHORT_MAX
      size_word = "long" if new_wordcount > MED_MAX
      size_word = "epic" if new_wordcount > LONG_MAX
    end
    Rails.logger.debug "#{self.title} new wordcount: #{new_wordcount} and size: #{size_word}"
    self.update_columns wordcount: new_wordcount, size: size_word
    return self
  end

  BASE_URL_PLACEHOLDER = "Base URL (* will be replaced)"
  URL_SUBSTITUTIONS_PLACEHOLDER = "replacements: n-m or space separated"
  URLS_PLACEHOLDER = "Alternative to Base: one URL per line"

  has_and_belongs_to_many :tags, -> { distinct }
  belongs_to :parent, class_name: "Page", optional: true
#  belongs_to :ultimate_parent, class_name: "Page", optional: true
  def ultimate_parent  # note: ultimate parent is self, not nil, if self has no parent...
    if parent_id.blank?
      self
    else
      parent.ultimate_parent
    end
  end

  attr_accessor :base_url
  attr_accessor :url_substitutions
  attr_accessor :urls

  before_validation :remove_placeholders, :normalize_url

  validates_presence_of :title, :message => "can't be blank"
  validates_format_of :url, :with => URI.regexp, :allow_blank => true
  validates_uniqueness_of :url, :allow_blank => true

  after_create :initial_fetch

  scope :with_content, -> { where(type: [Chapter, Single]) }
  def has_content?; raw_html.present? && parts.blank?; end

  def cn?; self.url && self.url.match(/clairesnook.com/); end
  def km?; self.url && self.url.match(/keiramarcos.com/); end
  def wp?; cn? || km? ; end

  def ao3?; self.url && self.url.match(/archiveofourown/); end
  def ao3_chapter?; ao3? && self.url.match(/chapter/); end

  def ff?; url && url.match(/fanfiction.net/); end
  def ff_chapter?; ff? && ff_chapter_number != "1"; end
  def ff_chapter_number; url.split("/s/").second.split("/").second; end
  def first_part_ff?; parts.any? && parts.first.ff?; end

  def chapter_url?; ao3_chapter? || ff_chapter?; end
  def chapter_as_single?; type == "Single" && chapter_url?; end

  def add_part(part_url)
    if parts.any?
      position = parts.last.position + 1
    else
      position = 1
    end
    if part_url.blank?
      title = "Part #{position}"
      page = Page.create!(:title=>title, :parent_id=>self.id, :position => position)
      page.set_type
    else
      page = Page.find_by(url: part_url)
      if page.blank?
        title = "Part #{position}"
        page = Page.create!(:url=>part_url, :title=>title, :parent_id=>self.id, :position => position)
        page.set_type
        # Rails.logger.debug "created #{page.reload.inspect}"
        self.update_attribute(:read_after, Time.now) if self.read_after > Time.now
        page.set_wordcount
      else
        Rails.logger.debug "found #{page}"
        page.update!(position: position, parent_id: self.id)
      end
    end
    self.update_from_parts
  end

  def parts_from_urls(url_title_list, refetch = false)
    Rails.logger.debug "#{refetch ? 're' : ''}fetch parts from urls: #{url_title_list}"
    old_part_ids = self.parts.map(&:id)
    Rails.logger.debug "my old parts #{old_part_ids}"

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

    Rails.logger.debug "find or create parts #{parts}"
    parts.each do |part|
      url = title = position = nil
      url = part.sub(/#.*/, "")
      title = part.sub(/.*#/, "") if part.match("#")
      position = parts.index(part) + 1
      Rails.logger.debug "looking for url: #{url} and title: #{title} in position #{position}"
      page =
        if url.present?
          Page.find_by(url: url)
        else
          Page.find_by(title: title, parent_id: self.id) ||
            possibles = Page.where(title: title)
            possibles.first if possibles && possibles.size == 1
        end
      if page.blank?
        title = "Part #{position}" if title.blank?
        Rails.logger.debug "didn't find #{part}"
        page = Page.create(:url=>url, :title=>title, :parent_id=>self.id, :position => position)
        page.set_type
        # Rails.logger.debug "created #{page.reload.inspect}"
        self.update_attribute(:read_after, Time.now) if self.read_after > Time.now
        page.set_wordcount
      else
        Rails.logger.debug "found #{part}"
        if page.url == url
          page.fetch_raw if refetch
        elsif url.present?
          page.update!(:url, url)
          page.fetch_raw
        end
        page.update!(position: position) if page.position != position
        page.update!(parent_id: self.id) if page.parent_id != self.id
        page.update!(title: title) if title && page.title != title
      end
      new_part_ids << page.id
    end
    Rails.logger.debug "parts found or created: #{new_part_ids}"

    remove = old_part_ids - new_part_ids
    Rails.logger.debug "removing deleted parts #{remove}"
    remove.each do |old_part_id|
      Page.find(old_part_id).make_single
    end

    self.update_from_parts
    self.set_type
  end

  def parts; Page.order(:position).where(["parent_id = ?", id]); end
  def previous_parts; Page.order(:position).where(["parent_id = ?", parent_id]).where("position < ?", position); end

  def next_part
    return nil unless parent
    my_index = parent.parts.find_index(self)
    return nil if my_index.nil?
    if parent.parts[my_index+1]
      return parent.parts[my_index+1]
    elsif parent.next_part
      if parent.next_part.parts.blank?
        return parent.next_part
      else
        return parent.next_part.parts.first
      end
    end
  end

  def previous_part
    return nil unless parent
    my_index = parent.parts.find_index(self)
    return nil if my_index.nil?
    if parent.parts[my_index-1]
      return parent.parts[my_index-1]
    elsif parent.previous_part
      if parent.previous_part.parts.blank?
        return parent.previous_part
      else
        return parent.previous_part.parts.last
      end
    end
  end

  def last_chapter?
    return nil unless parent
    parent.parts.last == self
  end

  def last_chapter_of_book_of_series?
    return false unless parent
    return true if parent.is_a?(Series) && self.is_a?(Single)
    return true if parent.is_a?(Book) && parent.parent&.is_a?(Series) && self.last_chapter?
    return false
  end

  def book_title
    raise "why am i being called" unless last_chapter_of_book_of_series?
    return title if self.is_a?(Single)
    return parent.title if parent.is_a?(Book)
    raise "what have i missed?"
  end

  def not_hidden_parts; parts.where(hidden: false); end

  def url_list
    return unless parts.present?
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

  def url_list_length
    return 33 if url_list.blank?
    url_list.split("\n").sort_by{|line| line.length}.last.length
  end

  def refetch_url; url || parts.first.url.split("/chapter").first; end

  def last_url; parts.any? ? parts.last.url : nil; end
  def last_url_length; last_url ? last_url.length : 33; end

  def make_single
    Rails.logger.debug "removing #{self.id} from #{self.parent_id}"
    return unless parent
    parent = self.parent
    self.tags << parent.tags - self.tags
    self.update(parent_id: nil, position: nil)
    self.set_type
    set_meta
  end

  def refetch(passed_url)
    if ao3? && type == "Single" && !url.match(/chapters/)
      if self.make_me_a_chapter
        parent = Book.create! url: passed_url
        update! parent_id: parent.id
        move_tags_up
        move_soon_up
        set_meta
        return parent.reload
      else
        update!(url: passed_url) if passed_url.present?
        fetch_ao3
        return self
      end
    else
      update!(url: passed_url) if passed_url.present?
      Rails.logger.debug "refetching all for #{id} url: #{self.url}"
      if ao3?
        page = becomes!(ao3_type)
        page.fetch_ao3
        page.errors.messages.each{|e| self.errors.add(e.first, e.second.join_comma)}
        return page
      elsif ff?
        errors.add(:base, "can't refetch from fanfiction.net")
        return self
      else
        fetch_raw
        set_meta if wp?
        self.parent.set_wordcount(false) if self.parent
        return self
      end
    end
  end

  def parent_type(current)
    current = "Book" unless current
    new =
      case type
      when "Chapter", nil
        "Book"
      when "Single"
        ao3? ? "Series" : "Book"
      when "Book"
        "Series"
      when "Series"
        "Collection"
      end
    [current, new].sort_by {|x| %w{Collection Series Book Single Chapter}.index(x)}.first.constantize
  end

  def increase_type
    current = self.type
    new = case type
          when nil
            "Chapter"
          when "Chapter"
            "Single"
          when "Single"
            "Book"
          when "Book"
            "Series"
          else
            "Collection"
          end
    update type: new
  end

  def decrease_type
    current = self.type
    new = case type
          when "Collection"
            "Series"
          when "Series"
            "Book"
          when "Book"
            "Single"
          else
            "Chapter"
          end
    update type: new
  end

  def add_parent(title)
    parent=Page.find_by_title(title)
    Rails.logger.debug "parent #{title} found? #{parent.is_a?(Page)}"
    new = false
    if parent.is_a?(Page)
      return "content" if parent.has_content?
    else
      pages=Page.where(["Lower(title) LIKE ?", "%" + title.downcase + "%"])
      potentials = pages.reject {|p| p.has_content?}
      if potentials.size > 1
        Rails.logger.debug "#{potentials.size} possible parents found"
        return potentials.to_a
      elsif potentials.empty?
        Rails.logger.debug "creating a new parent"
        parent = Page.create!(title: title, type: parent_type(self.type))
        new = true
      else
        Rails.logger.debug "matching parent found #{potentials.first.title}"
        parent = potentials.first
        parent.update!(type: parent_type(parent.type))
      end
    end
    add_parent_with_id(parent.id)
    move_tags_up if new
    return Page.find(parent.id)
  end

  def move_tags_up
    return unless parent.present?
    Rails.logger.debug "moving tags to parent"
    parent.tags << self.tags - self.tags.readers
    self.tags = self.tags.readers
    if self.hidden?
      Rails.logger.debug "moving hidden state to parent"
      self.unset_hidden
      parent.set_hidden
    end
    if self.con?
      Rails.logger.debug "moving con state to parent"
      self.unset_con
      parent.set_con
    end
    if self.pro?
      Rails.logger.debug "moving pro state to parent"
      self.unset_pro
      parent.set_pro
    end
  end

  def add_parent_with_id(parent_id)
    parent=Page.find(parent_id)
    Rails.logger.debug "adding #{self.type} with title #{self.title} to #{parent.type} with title #{parent.title}"
    count = parent.parts.size + 1
    self.update!(parent_id: parent.id, position: count)
    if self.type == "Single" && (parent.type == "Single" || parent.type == "Book")
      self.update!(type: Chapter, notes: "") && parent.update!(type: Book)
    end
    parent.update_from_parts
    page = Page.find(self.id)
    page.parent.set_meta
    page.set_meta
    page.remove_duplicate_tags
    return page.position
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
      #Rails.logger.debug "last read #{last_read.to_date}"
      last_read.to_date
    elsif unread_parts?
      suffix = unread_parts.size == 1 ? "" : "s"
      initial_string = "#{unread_parts.size} #{UNREAD} part#{suffix}"
      unless read_parts.empty?
        #Rails.logger.debug "read parts"
        read_dates = read_parts.map(&:last_read)
      else
        #Rails.logger.debug "no read parts, searching subparts"
        subparts = parts.map(&:parts).flatten
        read_dates = subparts.map(&:last_read).compact
        read_dates.delete(UNREAD_PARTS_DATE)
      end
      if read_dates.empty?
        #Rails.logger.debug "all parts & subparts last read never"
        initial_string
      else
        #Rails.logger.debug "last read dates: #{read_dates}"
        initial_string + " (#{read_dates.sort.first.to_date})"
      end
    elsif unread?
      #Rails.logger.debug "last read never"
      unread_string
    end
  end
  def formatted_my_notes; Scrub.sanitize_html(my_notes); end
  def formatted_notes; Scrub.sanitize_html(notes); end
  def formatted_end_notes; Scrub.sanitize_html(end_notes); end

  # used in show view
  def medium_notes
    return "" if notes.blank?
    Scrub.sanitize_html(notes.truncate(MEDIUM_LENGTH, separator: /\s/)).html_safe
  end

  # used in index view and in epub comments
  # RubyPants turns quotes into smart quotes which don't mess up the epub command
  def short_notes; RubyPants.new(Scrub.sanitize_and_strip(notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end
  def short_my_notes; RubyPants.new(Scrub.sanitize_and_strip(my_notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end
  def short_end_notes; RubyPants.new(Scrub.sanitize_and_strip(end_notes).truncate(SHORT_LENGTH, separator: /\s/)).to_html.html_safe; end

  def add_tags_from_string(string, type="Tag")
    return if string.blank?
    Rails.logger.debug "adding #{type} #{string}"
    self.set_hidden if type == "Hidden"
    self.set_con if type == "Con"
    self.set_pro if type == "Pro"
    string.split(",").each do |tag|
      typed_tag = type.constantize.find_by_short_name(tag.squish)
      typed_tag = type.constantize.find_or_create_by(name: tag.squish) unless typed_tag
      self.tags << typed_tag unless self.tags.include?(typed_tag)
    end
    Rails.logger.debug "tags now #{self.tags.joined}"
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
      Rails.logger.debug "stars are #{self.stars}, should be 5,4,3,2,1,9,or 10"
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

  def re_sanitize
    Rails.logger.debug "re_sanitizing #{self.id}"
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

  def scrub_fetch(url)
    begin
      Rails.logger.debug "fetching raw html from #{url}"
      Scrub.fetch_html(url)
    rescue SocketError
      Rails.logger.debug "host unavailable"
      self.errors.add(:base, "couldn't resolve host name")
      return false
    rescue
      Rails.logger.debug "content unavailable"
      self.errors.add(:base, "error retrieving content")
      return false
    end
  end

  def fetch_raw
    remove_outdated_downloads
    return false if ff?
    html = scrub_fetch(self.url)
    if html
      self.raw_html = html
      return self
    else
      return false
    end
  end

  def raw_html_file_name
    FileUtils.mkdir_p(mydirectory) # make sure directory exists
    self.mydirectory + "raw.html"
  end

  def build_clean_from_raw
    html = Websites.getnode(raw_html, self.url)
    if html
      Rails.logger.debug "updating scrubbed html from raw"
      self.scrubbed_html = Scrub.sanitize_html(html)
    else
      Rails.logger.debug "no scrubbed html available from raw"
      self.scrubbed_html = ""
    end
    self.set_wordcount
  end

  def raw_html=(content)
    remove_outdated_downloads
    body = Scrub.regularize_body(content)
    File.open(self.raw_html_file_name, 'w:utf-8') { |f| f.write(body) }
    build_clean_from_raw
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
      set_wordcount(false)
    else
      build_clean_from_raw
    end
    return self
  end

  ## Clean html includes all the original text

  def scrubbed_html_file_name
    self.mydirectory + "scrubbed.html"
  end

  def scrubbed_html=(content)
    remove_outdated_downloads
    remove_outdated_edits
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

  ### epub html is what I use for conversion
  ### ebook-convert silently drops all http images, so might as well try https
  ### even if https doesn't exist, I'm no worse off than before

  def epub_html
    edited_html.gsub('img src="http://', 'img src="https://')
  end

  def make_audio  # add an audio tag and mark it as read today
    Rails.logger.debug "mark_audio for #{self.id}"
    audio_tag = Tag.find_by(name: "audio") || Info.create(name: "audio")
    reader_tag = Reader.find_or_create_by(name: "Sidra")
    self.tags << [audio_tag, reader_tag]
    self.update(:last_read => Time.now)
    self.update_read_after
  end

  def remove_outdated_edits
    return self unless self.id
    FileUtils.rm_f(self.scrubbed_html_file_name)
    FileUtils.rm_f(self.edited_html_file_name)
    self
  end

  def rebuild_meta
    Rails.logger.debug "rebuilding meta for #{self.id}"
    remove_outdated_downloads
    self.parts.map(&:rebuild_meta)
    set_meta
    return self
  end

private

  def remove_placeholders
    self.url = self.url == "URL" ? nil : self.url.try(:strip)
    self.base_url = nil if self.base_url == BASE_URL_PLACEHOLDER
    self.urls = nil if self.urls == URLS_PLACEHOLDER
    self.url_substitutions = nil if self.url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    if self.title.blank? && self.url.blank? && self.base_url.blank? && self.urls.blank?
      self.errors.add(:base, "Both URL")
      return false
    end
    self.title = "temp" if self.title.blank?
    self.notes = nil if self.notes == "Notes"
    self.my_notes = nil if self.my_notes == "My Notes"
    self.read_after = Time.now if self.read_after.blank?
    self.sanitize_version = Scrub.sanitize_version
  end

  def initial_fetch
    # Rails.logger.debug "initial fetch for #{self.inspect}"
    Rails.logger.debug "initial fetch for #{self.title} (id: #{self.id})"
    FileUtils.rm_rf(mydirectory) # make sure directory is empty for testing
    FileUtils.mkdir_p(mydirectory) # make sure directory exists

    if self.url.present?
      if self.ao3? || self.wp?
        if type.nil?
          page = ao3? ? self.becomes!(initial_ao3_type) : self.becomes!(Single)
          Rails.logger.debug "page became #{page.type}"
        else
          page = self
        end
        ao3? ? page.fetch_ao3 : fetch_raw && set_meta
      elsif ff?
        set_type unless type and return
      else
        fetch_raw or return
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
        url = base_url.gsub(/\*/, sub.to_s)
        chapter = Page.find_by url: url
        if chapter
          chapter.update!(:position => count, :parent_id => self.id)
          Rails.logger.debug "found #{chapter.inspect}"
        else
          title = "Part " + count.to_s
          Rails.logger.debug "creating new chapter with title: #{title}"
          Chapter.create!(:title => title, :url => url, :position => count, :parent_id => self.id)
        end
        count = count.next
      end
      self.set_wordcount(false)
    elsif !self.urls.blank?
      self.parts_from_urls(self.urls)
    else
      self.set_wordcount
    end
    self.set_type unless type
    Rails.logger.debug "created as #{position.ordinalize} of #{parent.title}" if parent && position
    Rails.logger.debug "created with #{parts.size} parts" if parts.any?
  end


end
