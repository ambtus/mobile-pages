class Author < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Authors to add (comma separated)"

  has_and_belongs_to_many :pages, -> { distinct }
  default_scope { order('authors.name asc') }
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  scope :joined, -> { map(&:name).join(" & ") }

  before_validation :remove_placeholder

  def remove_placeholder
    self.name = nil if self.name == NEW_PLACEHOLDER
  end

  before_save :strip_whitespace

  def strip_whitespace
    self.name.squish!
  end

  def short_name
    name.split(" (").first
  end

  def self.find_by_short_name(short)
    return nil if short.blank?
    self.where(["name LIKE ?", short + "%"]).first
  end

  def self.names
    self.all.map(&:short_name)
  end

  def destroy_me
    pages = self.pages
    Rails.logger.debug "moving author to note for #{pages.size} pages"
    pages.each do |page|
      Rails.logger.debug "moving author to note for page #{id}"
      new_note = ["by #{self.name}", page.notes].join_hr
      page.update_attribute(:notes, new_note)
    end
    self.destroy
  end

end
