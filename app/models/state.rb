class State < ActiveRecord::Base

  UNREAD = "unread"
  FAVORITE = "favorite"
  SHORT = "short"
  LONG = "long"
  EPIC = "epic"
  SHORT_WC = 1000
  LONG_WC = 10000
  EPIC_WC = 80000

  has_and_belongs_to_many :pages, :uniq => true
  default_scope :order => 'states.name asc'
  validates_presence_of :name
  validates_uniqueness_of :name

end
