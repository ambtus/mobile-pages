class Tag < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Tags to add (comma separated)"

  has_and_belongs_to_many :pages, -> { distinct }
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  def self.types
    ["Fandom", "Character", "Trope", "Rating", "Omitted", "Hidden", "Info"]
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

  scope :not_fandom, -> { where.not(type: 'Fandom') }
  scope :not_character, -> { where.not(type: 'Character') }
  scope :not_hidden, -> { where.not(type: 'Hidden') }
  scope :not_omitted, -> { where.not(type: 'Omitted') }
  scope :not_rating, -> { where.not(type: 'Rating') }
  scope :not_info, -> { where.not(type: 'Info') }

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

  def self.names
    self.trope.by_name.map(&:name)
  end

  def destroy_me
    Rails.logger.debug "DEBUG: recaching page ids for #{self.name}"
    page_ids = self.pages.map(&:id)
    Rails.logger.debug "DEBUG: recaching page ids for #{pages.count} pages"
    self.destroy
    page_ids.each do |id|
      Rails.logger.debug "DEBUG: recaching page ids for #{id}"
      Page.find(id).cache_tags
    end
  end

end
