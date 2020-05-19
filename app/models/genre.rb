class Genre < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Genres to add (comma separated)"

  has_and_belongs_to_many :pages, -> { distinct }
  default_scope { order('genres.name asc') }
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  before_validation :remove_placeholder

  def remove_placeholder
    self.name = nil if self.name == NEW_PLACEHOLDER
  end

  before_save :strip_whitespace

  def strip_whitespace
    self.name.squish!
  end

  def self.names
    self.all.map(&:name)
  end

  def destroy_me
    Rails.logger.debug "recaching page ids for #{self.name}"
    page_ids = self.pages.map(&:id)
    Rails.logger.debug "recaching page ids for #{pages.count} pages"
    self.destroy
    page_ids.each do |id|
      Rails.logger.debug "recaching page ids for #{id}"
      Page.find(id).cache_genres
    end
  end

end
