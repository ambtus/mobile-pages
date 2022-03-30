class Author < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Authors to add (comma separated)"

  has_and_belongs_to_many :pages, -> { distinct }
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  scope :by_name, -> { order('authors.name asc') }
  scope :joined, -> { map(&:name).join(" & ") }

  before_validation :remove_placeholder

  def remove_placeholder
    self.name = nil if self.name == NEW_PLACEHOLDER
  end

  before_save :strip_whitespace

  def strip_whitespace
    self.name.squish!
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
  def true_name; short_names.first; end

  def add_aka(aka_author)
    all_names = (self.short_names + aka_author.short_names).uniq.join_comma
    true_name, akas = all_names.split(', ')
    new_name = "#{true_name} (#{akas})"
    Rails.logger.debug "DEBUG: merge #{aka_author.name} into #{self.name} as #{new_name}"
    self.update_attribute(:name, new_name)
    aka_author.pages.each {|p| p.authors << self unless p.authors.include?(self)}
    aka_author.destroy
    self
  end

  def self.find_by_short_name(short)
    return nil if short.blank?
    self.where(["name LIKE ?", "%" + short + "%"]).first
  end

  def self.names
    self.all.map(&:short_names).flatten.sort_by(&:downcase)
  end

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "DEBUG: moving author to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      Rails.logger.debug "DEBUG: moving author to note for page #{id}"
      page = Page.find(id)
      page.add_author(name).save!
    end
  end

end
