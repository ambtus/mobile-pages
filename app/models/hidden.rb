class Hidden < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Hidden genres to add (comma separated)"

  has_and_belongs_to_many :pages, :uniq => true
  default_scope :order => 'hiddens.name asc'
  validates_presence_of :name
  validates_uniqueness_of :name

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
      Page.find(id).cache_hiddens
    end
  end

  def make_genre
    new = Genre.find_or_create_by_name(name)
    pages.each do |page|
      page.genres << new
      page.cache_genres
    end
    destroy_me
  end
end
