# encoding=utf-8
# frozen_string_literal: true

class Page < ApplicationRecord
  include Download
  include Meta
  include SpecialTags
  include Rate
  include Utilities
  include Nodes
  include Soon
  include Split
  include Notes
  include Raw
  include Scrubbed

  scope :reading, -> { where(soon: 0) }
  scope :soonest, -> { where(soon: 1) }
  scope :random, -> { order(Arel.sql('RAND()')) }
  scope :recent, -> { order('updated_at desc') }
  scope :unread, -> { where(last_read: nil) }
  scope :unread_parts, -> { where(last_read: UNREAD_PARTS_DATE) }
  scope :read, -> { where.not(last_read: [nil, UNREAD_PARTS_DATE]) }
  scope :best, -> { where(stars: 5) }
  scope :okay, -> { where(stars: 4) }
  scope :bad, -> { where(stars: 3) }
  scope :unrated, -> { where(stars: 10) }
  scope :old_rating, -> { where.not(stars: [3, 4, 5, 10]) }
  scope :favorite, -> { where(favorite: true) }
  scope :wip, -> { where(wip: true) }
  scope :with_content, -> { where(type: [Chapter, Single]) }
  scope :with_parts, -> { where(type: [Book, Series]) }
  scope :with_tags, -> { where(type: [Book, Single]) }
  scope :has_no_parent, -> { where(parent_id: nil) }
  scope :has_parent, -> { where.not(parent_id: nil) }

  MODULO = 1000 # files in a single directory
  LIMIT = 5 # number of parts to show at a time

  def normalize_url
    return if url.blank?

    normalized = url.normalize
    if normalized.blank?
      errors.add(:url, 'is invalid')
      return false
    elsif normalized.match?('archiveofourown.org/users')
      errors.add(:url, 'cannot be ao3 user')
      return false
    elsif normalized.match('(.*)/collections/(.*)/works/(.*)')
      normalized = "#{::Regexp.last_match(1)}/works/#{::Regexp.last_match(3)}"
    elsif normalized.match?('archiveofourown.org/collections')
      errors.add(:url, 'cannot be an ao3 collection')
      return false
    end
    self.url = normalized
  end

  def self.find_parent_by_url(url)
    if url.match('(.*)archiveofourown.org/works/(.*)/chapters/(.*)')
      parent_url = "#{::Regexp.last_match(1)}archiveofourown.org/works/#{::Regexp.last_match(2)}"
      Book.find_by(url: parent_url)
    elsif url.match('(.*)fanfiction.net/s/(.*)/(.*)')
      parent_url = "#{::Regexp.last_match(1)}fanfiction.net/s/#{::Regexp.last_match(2)}"
      Rails.logger.debug { "parent url: #{parent_url}" }
      Book.find_by(url: parent_url)
    else
      false
    end
  end

  def ao3_type
    case url
    when /chapters/
      parent ? Chapter : Single
    when /works/
      parts.empty? ? Single : Book
    when /series/
      Series
    else
      raise "what's my ao3_type?"
    end
  end

  def initial_ao3_type
    case url
    when /chapters/
      parent ? Chapter : Single
    when /works/
      Book
    when /series/
      Series
    else
      raise "what's my initial_ao3_type?"
    end
  end

  def set_type
    # Rails.logger.debug "setting type for #{self.inspect}"
    if ao3?
      Rails.logger.debug { "ao3 type set to #{ao3_type}" }
      update!(type: ao3_type)
    else
      should_be =
        if parts.empty?
          parent_id.nil? ? Single : Chapter
        else
          part_types = parts.map(&:type).uniq.compact
          Rails.logger.debug { "part types: #{part_types}" }
          if (part_types - ['Chapter']).empty?
            Book
          else
            Series
          end
        end
      Rails.logger.debug { "non-ao3 type set to #{should_be} for #{title}" }
      update!(type: should_be)
    end
    parent&.set_type
  end

  def mypath
    prefix = case Rails.env
             when 'test' then '/tmp/test/'
             when 'development' then '/tmp/files/'
             when 'production' then '/files/'
             end
    "#{prefix}#{id / MODULO}/#{id}/"
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

  SIZES = %w[drabble short medium long epic].freeze

  DRABBLE_MAX = 300
  SHORT_MAX = 3000
  MED_MAX   = 30_000
  LONG_MAX = 300_000

  def reset_booleans
    Tag.boolean_types.each do |thing|
      send("#{thing.downcase}=", tags.where(type: thing).present?)
    end
  end

  def new_wordcount(recount = true)
    if parts.size.positive?
      Rails.logger.debug { "getting wordcount for #{title} from parts" }
      parts.each(&:set_wordcount) if recount
      parts.sum(:wordcount)
    elsif recount && has_content?
      Rails.logger.debug { "getting wordcount for #{title} by recounting" }
      body = Nokogiri::HTML(edited_html).xpath('//body').first
      if body.blank?
        0
      else
        count = 0
        body.traverse do |node|
          if node.is_a? Nokogiri::XML::Text
            words = node.inner_text.gsub('--', '—').gsub(/(['’‘-])+/, '')
            count += words.scan(/[a-zA-Z0-9À-ÿ_]+/).size
          end
        end
        if count.zero?
          Rails.logger.debug { "setting wordcount for #{title} to -1 because body but no text implies image only" }
          -1
        else
          count
        end
      end
    else
      Rails.logger.debug { "getting wordcount for #{title} from previous count" }
      wordcount || 0
    end
  end

  def set_wordcount(recount = true)
    # Rails.logger.debug "#{self.title} old wordcount: #{self.wordcount} and size: #{self.size}"
    newwc = new_wordcount(recount)
    size_word = 'drabble'
    if newwc
      size_word = 'short' if newwc > DRABBLE_MAX
      size_word = 'medium' if newwc > SHORT_MAX
      size_word = 'long' if newwc > MED_MAX
      size_word = 'epic' if newwc > LONG_MAX
    end
    Rails.logger.debug { "#{title} new wordcount: #{newwc} and size: #{size_word}" }
    update_columns wordcount: newwc, size: size_word
    self
  end

  BASE_URL_PLACEHOLDER = 'Base URL (* will be replaced)'
  URL_SUBSTITUTIONS_PLACEHOLDER = 'replacements: n-m or space separated'
  URLS_PLACEHOLDER = 'Alternative to Base: one URL per line'

  has_and_belongs_to_many :tags, -> { distinct }
  belongs_to :parent, class_name: 'Page', optional: true

  # NOTE: ultimate parent is self, not nil, if self has no parent...
  def ultimate_parent
    if parent.blank?
      self
    else
      parent.ultimate_parent
    end
  end

  attr_accessor :base_url, :url_substitutions, :urls

  before_validation :remove_placeholders, :normalize_url

  validates :title, presence: { message: "can't be blank" }
  validates :url, format: { with: URI::RFC2396_PARSER.make_regexp, allow_blank: true }
  validates :url, uniqueness: { allow_blank: true }

  before_save :update_tag_cache
  before_save :reset_booleans
  after_create :initial_fetch

  def can_have_tags? = %w[Single Book].include?(type) || type.blank?
  def tag_types = can_have_tags? ? Tag.types : Tag.some_types

  def can_have_parts? = %w[Book Series].include?(type)

  def some_parts
    return [] unless can_have_parts?

    [parts.first, parts[parts.size / 2], parts.last].pulverize
  end

  def update_tag_cache = self.tag_cache = (base_tags)

  def base_tags
    case type
    when 'Chapter', 'Single', 'Book'
      tags.map(&:base_name).join_comma
    when 'Series'
      (tags + some_parts.map(&:shared_tags)).pulverize.map(&:base_name).join_comma
    else # shouldn't get here, but...
      Rails.logger.debug { "page #{id} doesn't have a proper type" }
      ''
    end
  end

  def cached_tags = Tag.all.select { |t| tag_cache.split_comma.include?(t.base_name) }

  def shared_tags = tags.authors + tags.fandoms

  def could_have_content? = %w[Chapter Single].include?(type)
  def could_have_parts? = %w[Book Series].include?(type)
  def could_have_url? = could_have_content? || ao3? || ao3_chapters?

  def has_content?
    raw_html.present? && parts.blank?
  rescue StandardError
  end

  def cn? = url&.match(/clairesnook.com/)
  def km? = url&.match(/keiramarcos.com/)
  def wp? = cn? || km?
  def wikipedia? = url&.match(/wikipedia.org/)

  def ao3? = url&.include?('archiveofourown')
  def ao3_chapter? = ao3? && url.include?('chapter')
  def ao3_chapters? = parts.first&.ao3?
  def ao3_work? = ao3? && url.include?('work') && url.exclude?('chapter')
  def not_ao3_series? = ao3? && url.exclude?('series')

  def ff? = url&.match(/fanfiction.net/)
  def ff_chapter? = ff? && ff_chapter_number != '1'
  def ff_chapter_number = url.split('/s/').second.split('/').second
  def first_part_ff? = parts.any? && parts.first.ff?

  def chapter_url? = ao3_chapter? || ff_chapter?
  def chapter_as_single? = type == 'Single' && chapter_url?

  def add_part(part_url)
    position = if parts.any?
                 parts.last.position + 1
               else
                 1
               end
    if part_url.blank?
      title = "Part #{position}"
      page = Page.create!(title: title, parent_id: id, position: position)
      page.set_type
    else
      page = Page.find_by(url: part_url)
      if page.blank?
        title = "Part #{position}"
        page = Page.create!(url: part_url, title: title, parent_id: id, position: position)
        page.set_type
        # Rails.logger.debug "created #{page.reload.inspect}"
        update_attribute(:read_after, Time.zone.now) if read_after > Time.zone.now
        page.set_wordcount
      else
        Rails.logger.debug { "found #{page}" }
        page.update!(position: position, parent_id: id)
      end
    end
    update_from_parts
  end

  def parts_from_urls(url_title_list, refetch = false)
    Rails.logger.debug { "#{'re' if refetch}fetch parts from urls: #{url_title_list}" }
    old_part_ids = parts.map(&:id)
    Rails.logger.debug { "my old parts #{old_part_ids}" }

    new_part_ids = []

    lines = url_title_list.split(/[\r\n]/).select(&:chomp).map(&:squish) - ['']

    parts_with_subparts = lines.select { |l| l.match('^##') }

    parts = if parts_with_subparts.blank?
              lines.reject { |l| l.match('^#') }
            else
              lines.select { |l| l.match('##') }
            end

    if parts.include?(url)
      errors.add(:url_list, 'can’t include your own url')
      return false
    end

    Rails.logger.debug { "find or create parts #{parts}" }
    parts.each do |part|
      title = nil
      url = part.sub(/#.*/, '')
      title = part.sub(/.*#/, '') if part.match?('#')
      position = parts.index(part) + 1
      Rails.logger.debug { "looking for url: #{url} and title: #{title} in position #{position}" }
      page =
        if url.present?
          Page.find_by(url: url)
        else
          Page.find_by(title: title, parent_id: id) ||
            possibles = Page.where(title: title)
          possibles.first if possibles && possibles.size == 1
        end
      if page.blank?
        title = "Part #{position}" if title.blank?
        Rails.logger.debug { "didn't find #{part}" }
        page = Page.create(url: url, title: title, parent_id: id, position: position)
        page.set_type
        # Rails.logger.debug "created #{page.reload.inspect}"
        update_attribute(:read_after, Time.zone.now) if read_after > Time.zone.now
        page.set_wordcount
      else
        Rails.logger.debug { "found #{part}" }
        if page.url == url
          page.fetch_raw if refetch
        elsif url.present?
          page.update!(:url, url)
          page.fetch_raw
        end
        page.update!(position: position) if page.position != position
        page.update!(parent_id: id) if page.parent_id != id
        page.update!(title: title) if title && page.title != title
      end
      new_part_ids << page.id
    end
    Rails.logger.debug { "parts found or created: #{new_part_ids}" }

    remove = old_part_ids - new_part_ids
    Rails.logger.debug { "removing deleted parts #{remove}" }
    remove.each do |old_part_id|
      Page.find(old_part_id).make_single
    end

    update_from_parts
    set_type
  end

  def parts = Page.order(:position).where(parent_id: id)

  def unread_previous
    Page.order(:position).where(parent_id: parent_id).where(position: ...position).where(last_read: [nil,
                                                                                                     UNREAD_PARTS_DATE])
  end

  def all_previous = Page.order(:position).where(parent_id: parent_id).where(position: ...position)

  def next_part
    return nil unless parent

    my_index = parent.parts.find_index(self)
    return nil if my_index.nil?

    if parent.parts[my_index + 1]
      parent.parts[my_index + 1]
    elsif parent.next_part
      return parent.next_part if parent.next_part.parts.blank?

      parent.next_part.parts.first

    end
  end

  def previous_part
    return nil unless parent

    my_index = parent.parts.find_index(self)
    return nil if my_index.nil?
    return nil if my_index.zero?

    if parent.parts[my_index - 1]
      parent.parts[my_index - 1]
    elsif parent.previous_part
      return parent.previous_part if parent.previous_part.parts.blank?

      parent.previous_part.parts.last

    end
  end

  def last_chapter?
    return false unless parent

    parent.parts.last == self
  end

  def not_hidden_parts = parts.where(hidden: false)

  def url_list
    return if parts.blank?

    partregexp = /\APart \d+\Z/
    list = []
    parts.each do |part|
      if part.parts.blank?
        line = part.url
        unless part.title.match(partregexp)
          line ||= ''
          line = "#{line}###{part.title}"
        end
        list << line
      else
        list << "###{part.title}"
      end
    end
    list.join("\n")
  end

  def url_list_length
    return 33 if url_list.blank?

    url_list.split("\n").max_by(&:length).length
  end

  def refetch_url
    return url if ao3?
    return parts.first.url.split('/chapter').first if ao3_chapters?

    url.presence || ''
  end

  def last_url = parts.any? ? parts.last.url : nil
  def last_url_length = last_url ? last_url.length : 33

  def make_single
    Rails.logger.debug { "removing #{id} from #{parent_id}" }
    return unless parent

    old_parent = parent
    self.parent_id = nil
    self.position = nil
    set_type
    tags << (old_parent.tags - tags)
    set_meta
  end

  # only used when make_me_a_chapter
  def move_tags_up
    return if parent.blank?

    Rails.logger.debug 'moving tags to parent'
    parent.tags << (tags - tags.readers)
    parent.save!
    self.tags = tags.readers
    save!
  end

  def refetch(passed_url)
    if ao3? && type == 'Single' && url.exclude?('chapters')
      if make_me_a_chapter(passed_url)
        move_tags_up
        move_soon_up
        set_meta
        parent.reload
      else
        update!(url: passed_url) if passed_url.present?
        fetch_ao3
        self
      end
    else
      update!(url: passed_url) if passed_url.present?
      Rails.logger.debug { "refetching all for #{id} url: #{url}" }
      if ao3?
        page = becomes!(ao3_type)
        page.fetch_ao3
        page.errors.messages.each { |e| errors.add(e.first, e.second.join_comma) }
        page
      elsif ff?
        errors.add(:base, "can't refetch from fanfiction.net")
        self
      else
        fetch_raw
        set_meta if wp?
        parent&.set_wordcount(false)
        self
      end
    end
  end

  def parent_type(_current)
    case type
    when 'Chapter', nil
      Book
    when 'Single'
      ao3? ? 'Series' : 'Book'
    else
      Series
    end
  end

  def increase_type
    new = case type
          when nil, 'Chapter'
            'Single'
          when 'Single'
            'Book'
          when 'Book'
            'Series'
          else
            raise 'cannot increase type'
          end
    update type: new
    return unless new == 'Single' && parent&.type == 'Book'

    parent.increase_type
    parent.parts.where(type: 'Chapter').map(&:increase_type)
  end

  def decrease_type
    new = case type
          when 'Series'
            'Book'
          when 'Book'
            'Single'
          when 'Single'
            'Chapter'
          else
            raise 'cannot decrease type'
          end
    update type: new
    parts.map(&:decrease_type) if new == 'Book'
  end

  def add_parent(title)
    normalized = title.normalize
    parent = nil
    if normalized.present?
      parent = Page.find_by(url: normalized)
      Rails.logger.debug { "page #{normalized} found by url" }
    else
      parent = Page.find_by(title: title)
      Rails.logger.debug { "page #{title} found by title" }
    end
    if parent.is_a?(Page)
      if parent.has_content?
        Rails.logger.debug 'page has content and cannot be a parent'
        return 'content'
      else
        Rails.logger.debug 'page can be a parent'
      end
    elsif normalized.present?
      Rails.logger.debug 'cannot make a parent with url as title'
      return 'normalized'
    else
      pages = Page.where(['Lower(title) LIKE ?', "%#{title.downcase}%"])
      potentials = pages.reject(&:has_content?)
      if potentials.size > 1
        Rails.logger.debug { "#{potentials.size} possible parents found" }
        return potentials.to_a
      elsif potentials.empty?
        Rails.logger.debug 'creating a new parent'
        parent = Page.create!(title: title, type: parent_type(type))
      else
        Rails.logger.debug { "matching parent found #{potentials.first.title}" }
        parent = potentials.first
        parent.update!(type: parent_type(parent.type))
      end
    end
    add_parent_with_id(parent.id)
    Page.find(parent.id)
  end

  def add_parent_with_id(parent_id)
    parent = Page.find(parent_id)
    Rails.logger.debug { "adding #{type} with title #{title} to #{parent.type} with title #{parent.title}" }
    count = parent.parts.size + 1
    update!(parent_id: parent.id, position: count)
    if type == 'Single' && %w[Single Book].include?(parent.type)
      Rails.logger.debug 'making me a chapter'
      update!(type: Chapter, notes: '') && parent.update!(type: Book)
      move_tags_up
    end
    parent.update_from_parts
    parent.set_meta
    position
  end

  def parts_string
    suffix = parts.size == 1 ? '' : 's'
    parts.blank? ? '' : " (#{parts.size} part#{suffix})"
  end

  def size_string
    "#{ActionController::Base.helpers.number_with_delimiter(wordcount)} words" + parts_string
  end

  def last_read_string
    if read?
      # Rails.logger.debug "last read #{last_read.to_date}"
      last_read.to_date
    elsif unread_parts?
      suffix = unread_parts.size == 1 ? '' : 's'
      initial_string = "#{unread_parts.size} #{UNREAD} part#{suffix}"
      if read_parts.empty?
        # Rails.logger.debug "no read parts, searching subparts"
        subparts = parts.map(&:parts).flatten
        read_dates = subparts.filter_map(&:last_read)
        read_dates.delete(UNREAD_PARTS_DATE)
      else
        # Rails.logger.debug "read parts"
        read_dates = read_parts.map(&:last_read)
      end
      if read_dates.empty?
        # Rails.logger.debug "all parts & subparts last read never"
        initial_string
      else
        # Rails.logger.debug "last read dates: #{read_dates}"
        initial_string + " (#{read_dates.min.to_date})"
      end
    elsif unread?
      # Rails.logger.debug "last read never"
      unread_string
    end
  end

  def add_tags_from_string(string, type = 'Tag')
    return if string.blank?

    Rails.logger.debug { "adding #{type} #{string}" }
    string.split(',').each do |try|
      name = try.squish
      exists = Tag.with_short_name(name)
      if exists
        if exists.type == type
          tags << exists unless tags.include?(exists)
        else
          Rails.logger.debug { "Tag #{exists} already exists" }
          errors.add(:base, 'duplicate short name')
          return false
        end
      else
        typed_tag = type.constantize.find_or_create_by(name: name.squish)
        tags << typed_tag unless tags.include?(typed_tag)
      end
    end
    save!
    Rails.logger.debug { "tags now #{tags.joined}" }
  end

  def unread_string = unread? ? UNREAD : ''



  ### epub html is what I use for conversion
  ### ebook-convert silently drops all http images, so might as well try https
  ### even if https doesn't exist, I'm no worse off than before

  def epub_html
    edited_html.gsub('img src="http://', 'img src="https://')
  end

  # add reader tag and mark it as read today
  def make_audio
    Rails.logger.debug { "mark_audio for #{id}" }
    reader_tag = Reader.find_or_create_by(name: 'Sidra')
    tags << reader_tag
    update(last_read: Time.zone.now, reader: true)
    update_read_after
  end

  def remove_outdated_edits
    return self unless id

    FileUtils.rm_f(scrubbed_html_file_name)
    FileUtils.rm_f(edited_html_file_name)
    self
  end

  def rebuild_meta
    Rails.logger.debug { "rebuilding meta for #{id}" }
    remove_outdated_downloads
    parts.map(&:rebuild_meta)
    remove_outdated_tags
    set_meta
    self
  end

  def remove_outdated_tags
    return if can_have_tags?

    tags.delete(tags.where(type: %w[Fandom Author]))
    save!
    self
  end

  def remove_directory = FileUtils.rm_rf(mydirectory)
  def make_directory = FileUtils.mkdir_p(mydirectory)

  private

  def remove_placeholders
    self.url = url == 'URL' ? nil : url.try(:strip)
    self.base_url = nil if base_url == BASE_URL_PLACEHOLDER
    self.urls = nil if urls == URLS_PLACEHOLDER
    self.url_substitutions = nil if url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
    if title.blank? && url.blank? && base_url.blank? && urls.blank?
      errors.add(:base, 'Both URL')
      return false
    end
    self.title = 'temp' if title.blank?
    self.notes = nil if notes == 'Notes'
    self.my_notes = nil if my_notes == 'My Notes'
    self.read_after = Time.zone.now if read_after.blank?
  end

  def initial_fetch
    # Rails.logger.debug "initial fetch for #{self.inspect}"
    Rails.logger.debug { "initial fetch for #{title} (id: #{id})" }
    remove_directory # make sure directory is empty for testing
    make_directory # make sure directory exists

    if self.url.present?
      Rails.logger.debug { "for url #{self.url}" }
      if ao3? || wp?
        if type.nil?
          page = ao3? ? becomes!(initial_ao3_type) : becomes!(Single)
          Rails.logger.debug { "page became #{page.type}" }
        else
          page = self
        end
        page.save! if ao3?
        # page.fetch_ao3 if ao3?
        fetch_raw && set_meta if wp?
      elsif ff?
        set_type unless type && return
      else
        fetch_raw or return
      end
    elsif base_url.present?
      Rails.logger.debug { "for base_url #{base_url}" }
      self.type = 'Book'
      if base_url.match?(/fanfiction.net/)
        Rails.logger.debug 'setting url for book'
        self.url = base_url.delete('*')
      end
      save!
      parent = Page.find(id)
      match = url_substitutions.match('-')
      array = if match
                match.pre_match.to_i..match.post_match.to_i
              else
                url_substitutions.split
              end
      count = 1
      array.each do |sub|
        url = base_url.gsub('*', sub.to_s)
        chapter = Page.find_by url: url
        if chapter
          chapter.update!(position: count, parent_id: parent.id)
          Rails.logger.debug { "found #{chapter.inspect}" }
        else
          title = "Part #{count}"
          Rails.logger.debug { "creating new chapter with title: #{title}" }
          Chapter.create!(title: title, url: url, position: count, parent_id: parent.id)
        end
        count = count.next
      end
      parent.set_wordcount(false)
    elsif urls.present?
      Rails.logger.debug { "for multiple urls #{urls}" }
      parts_from_urls(urls)
    else
      Rails.logger.debug 'no url(s)'
      set_wordcount
    end
    set_type unless type
    Rails.logger.debug { "created: #{inspect}" }
  end
end
