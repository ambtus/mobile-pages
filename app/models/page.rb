# encoding=utf-8
# frozen_string_literal: true

class Page < ApplicationRecord
  Module.constants.map(&:name).each do |x|
    next unless x.start_with?('Page')
    next if %w[Page PagesController].include? x

    include  Module.const_get(x)
  end

  FILE_PREFIXES = { test: '/tmp/test/', development: '/tmp/files/', production: '/files/' }.freeze
  MODULO = 1000 # files in a single directory
  LIMIT = 5 # number of parts to show at a time

  # make page.inspect easier to read in DEBUG Rails statements by shortening the dates
  def inspect
    regexp = /([\d-]+)( \d\d:\d\d[\d:.+ ]+)/
    super.match(regexp) ? super.gsub(regexp, '\1') : super
  end

  has_and_belongs_to_many :tags, -> { distinct }

  scope :reading, -> { where(soon: 0) }
  scope :soonest, -> { where(soon: 1) }
  scope :random, -> { order(Arel.sql('RAND()')) }
  scope :recent, -> { order(updated_at: :desc) }
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
  scope :has_no_parent, -> { where(parent_id: nil) }
  scope :has_parent, -> { where.not(parent_id: nil) }
  scope :with_tags, -> { where(type: [Book, Single]) }

  def self.find_parent_by_url(url)
    if url =~ Regexp.new('(.*)archiveofourown.org/works/(.*)/chapters/(.*)')
      parent_url = "#{::Regexp.last_match(1)}archiveofourown.org/works/#{::Regexp.last_match(2)}"
      Book.find_by(url: parent_url)
    elsif url =~ Regexp.new('(.*)fanfiction.net/s/(.*)/(.*)')
      parent_url = "#{::Regexp.last_match(1)}fanfiction.net/s/#{::Regexp.last_match(2)}"
      Rails.logger.debug { "parent url: #{parent_url}" }
      Book.find_by(url: parent_url)
    else
      false
    end
  end

  def set_type(reset: false)
    return if !reset && type.present?

    should_be = ao3? ? ao3_type_should_be : type_should_be
    Rails.logger.debug { "type should be #{should_be}" }
    update(type: should_be)

    parent&.set_type
  end

  def mypath
    prefix = FILE_PREFIXES.fetch(Rails.env.to_sym)
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

  BASE_URL_PLACEHOLDER = 'Base URL (* will be replaced)'
  URL_SUBSTITUTIONS_PLACEHOLDER = 'replacements: n-m or space separated'
  URLS_PLACEHOLDER = 'Alternative to Base: one URL per line'

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

  before_validation :remove_placeholders, on: :create
  before_validation :normalize_url

  validates :title, presence: { message: "can't be blank" }
  validates :url, format: { with: URI::RFC2396_PARSER.make_regexp, allow_blank: true }
  validates :url, uniqueness: { allow_blank: true }

  after_create :set_type, :prepare_directory

  def can_have_parts? = %w[Book Series].include?(type)

  def some_parts
    return [] unless can_have_parts?

    [parts.first, parts[parts.size / 2], parts.last].pulverize
  end

  def could_have_content? = %w[Chapter Single].include?(type)
  def could_have_parts? = %w[Book Series].include?(type)
  def could_have_url? = could_have_content? || ao3? || ao3_chapters?

  def has_content?
    return false if parts.present?

    begin
      (raw_html || edited_html).present?
    rescue ArgumentError # encoding error
      true
    end
  end

  def parts = Page.order(:position).where(parent_id: id)

  def unread_previous
    Page.order(:position).where(parent_id: parent_id).where(position: ...position).where(last_read: [nil,
                                                                                                     UNREAD_PARTS_DATE])
  end

  def not_hidden_parts = parts.where(hidden: false)

  def parts_string
    suffix = parts.size == 1 ? '' : 's'
    parts.blank? ? '' : " (#{parts.size} part#{suffix})"
  end

  def size_string
    "#{ActionController::Base.helpers.number_with_delimiter(wordcount)} words" + parts_string
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
    update_tag_caches
    update(last_read: Time.zone.now, reader: true)
    update_read_after
  end

  def remove_outdated_edits
    return self unless id

    FileUtils.rm_f(scrubbed_html_file_name)
    FileUtils.rm_f(edited_html_file_name)
    self
  end

  def rebuild_meta(rebuild_parts: true)
    Rails.logger.debug { "rebuilding meta for #{id}" }
    remove_outdated_downloads
    parts.map(&:rebuild_meta) if rebuild_parts
    remove_outdated_tags
    set_meta
    set_wordcount
    parent&.rebuild_meta(rebuild_parts: false)
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

  def initial_fetch
    Rails.logger.debug { 'initial fetch' }

    if url.present?
      fetch_by_url
    elsif base_url.present?
      fetch_by_pattern
    elsif urls.present?
      fetch_by_urls
    end
    Rails.logger.debug { "  created: #{inspect}" }
    self
  end

  private

  def prepare_directory = remove_directory && make_directory

  def remove_placeholders
    Rails.logger.debug { 'removing placeholders' }
    fix_urls
    fix_titles

    self.notes = nil if notes == 'Notes'
    self.my_notes = nil if my_notes == 'My Notes'
    self.read_after = Time.zone.now if read_after.blank?
  end

  def fix_urls
    self.url = url == 'URL' || url.blank? ? nil : url.strip
    self.base_url = nil if base_url == BASE_URL_PLACEHOLDER
    self.urls = nil if urls == URLS_PLACEHOLDER
    self.url_substitutions = nil if url_substitutions == URL_SUBSTITUTIONS_PLACEHOLDER
  end

  def fix_titles
    if title.blank? && url.blank? && base_url.blank? && urls.blank?
      errors.add(:base, 'Both URL')
      return false
    end
    self.title = TEMP_TITLE if title.blank?
  end
end
