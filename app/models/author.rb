class Author < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Authors to add (comma separated)"

  has_and_belongs_to_many :pages, -> { distinct }
  default_scope { order('authors.name asc') }
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

  def short_name
    name.split(" (").first
  end

  def self.names
    self.all.map(&:short_name)
  end
end
