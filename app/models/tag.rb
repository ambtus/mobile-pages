class Tag < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Tags to add (comma separated)"

  has_and_belongs_to_many :pages, -> { distinct }
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false, scope: :type

  def self.types
    ["Fandom", "Author", "Character", "Trope", "Rating", "Omitted", "Hidden", "Info"]
  end

  scope :by_name, -> { order('tags.name asc') }
  scope :by_type, -> { order('tags.type desc') }

  scope :trope, -> { where(type: '') }
  scope :fandom, -> { where(type: 'Fandom') }
  scope :character, -> { where(type: 'Character') }
  scope :hidden, -> { where(type: 'Hidden') }
  scope :omitted, -> { where(type: 'Omitted') }
  scope :rating, -> { where(type: 'Rating') }
  scope :info, -> { where(type: 'Info') }
  scope :author, -> { where(type: 'Author') }

  scope :not_fandom, -> { where.not(type: 'Fandom') }
  scope :not_character, -> { where.not(type: 'Character') }
  scope :not_hidden, -> { where.not(type: 'Hidden') }
  scope :not_omitted, -> { where.not(type: 'Omitted') }
  scope :not_rating, -> { where.not(type: 'Rating') }
  scope :not_info, -> { where.not(type: 'Info') }
  scope :not_author, -> { where.not(type: 'Author') }

  scope :joined, -> { map(&:name).join(", ") }

  before_validation :remove_placeholder

  def remove_placeholder
    self.name = nil if self.name == NEW_PLACEHOLDER
  end

  before_save :strip_whitespace

  def strip_whitespace
    self.name.squish!
  end

  def type_name
    type.blank? ? "Trope" : type
  end

  def self.scope_name
    self.name == "Tag" ? "trope" : self.name.downcase
  end

  def short_names
    if name.match(/([^\(]*) \((.*)\)/)
      true_name, aka_string = [$1, $2]
      akas = aka_string.split(", ")
      [true_name, *akas]
    else
      [name]
    end
  end

  def base_name; short_names.first; end

  def self.find_by_short_name(short)
    return nil if short.blank?
    return nil unless self.names.include?(short) # don't catch substring au for audio
    self.send(scope_name).where(["name LIKE ?", "%" + short + "%"]).first
  end

  def add_aka(aka_tag)
    all_names = (self.short_names + aka_tag.short_names).uniq.join_comma
    true_name, akas = all_names.split(', ')
    new_name = "#{true_name} (#{akas})"
    Rails.logger.debug "DEBUG: merge #{aka_tag.name} into #{self.name} as #{new_name}"
    self.update_attribute(:name, new_name)
    page_ids = aka_tag.pages.map(&:id)
    aka_tag.pages.each {|p| p.tags << self unless p.tags.include?(self)}
    aka_tag.destroy
    page_ids.each {|id| Page.find(id).cache_tags}
    self
  end

  def self.names
    self.send(scope_name).map(&:short_names).flatten.sort_by(&:downcase)
  end

  def recache(ids=self.pages.map(&:id))
    Rails.logger.debug "DEBUG: recaching tags for #{ids.count} pages"
    ids.each do |id|
      Rails.logger.debug "DEBUG: recaching tags for page #{id}"
      Page.find(id).cache_tags
    end
  end

  def destroy_me
    Rails.logger.debug "DEBUG: recaching pages for #{self.name}"
    page_ids = self.pages.map(&:id)
    self.destroy
    self.recache(page_ids)
  end

end
