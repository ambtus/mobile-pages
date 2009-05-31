class Genre < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Filters to add (comma separated)"
  UNREAD = "status: unread"
  FAVORITE = "status: favorite"
  SHORT = "genre: short"
  LONG = "genre: long"
  EPIC = "genre: epic"
  SHORT_WC = 1000
  LONG_WC = 10000
  EPIC_WC = 80000

  has_and_belongs_to_many :pages, :uniq => true
  default_scope :order => 'genres.name asc'
  validates_presence_of :name
  validates_uniqueness_of :name

  def before_validation
    self.name = nil if self.name == NEW_PLACEHOLDER
  end

  before_save :strip_whitespace

  def strip_whitespace
    self.name.squish!
  end

end
