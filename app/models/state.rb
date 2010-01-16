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
  
  def self.unread
    self.find_or_create_by_name(UNREAD)
  end
  def self.short
    self.find_or_create_by_name(SHORT)
  end
  def self.long
    self.find_or_create_by_name(LONG)
  end
  def self.epic
    self.find_or_create_by_name(EPIC)
  end
  def self.favorite
    self.find_or_create_by_name(FAVORITE)
  end
  
  def self.by_wordcount(wordcount)
    return self.short if wordcount < SHORT_WC
    return self.long if wordcount > LONG_WC && wordcount < EPIC_WC    
    return self.epic if wordcount > EPIC_WC
    return nil
  end

end
