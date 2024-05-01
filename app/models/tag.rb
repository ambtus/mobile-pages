class Tag < ActiveRecord::Base
  NEW_PLACEHOLDER = "Enter Tags to add (comma separated)"

  has_and_belongs_to_many :pages, -> { distinct }
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false, scope: :type

  def self.types; ["Fandom", "Author", "Pro", "Con", "Hidden", "Reader", "Info", "Collection"]; end
  def self.some_types; self.types - ["Fandom", "Author"]; end
  def self.boolean_types; self.some_types - ["Info", "Collection"]; end

  scope :by_name, -> { order('tags.name asc') }
  scope :by_type, -> { order('tags.type desc') }

  scope :title_suffixes, -> {where(type: Tag.boolean_types)}

  self.types.each do |type|
    scope type.downcase.pluralize.to_sym, -> { where(type: type)}
    scope "not_#{type.downcase}".to_sym, -> {where.not(type: type)}
  end

  scope :some, -> { not_author.not_fandom }

  # NOTE: this must go at the end, because it returns an array, not a scope
  scope :joined, -> { map(&:base_name).join_comma }

  before_validation :remove_placeholder

  def remove_placeholder
    self.name = nil if self.name == NEW_PLACEHOLDER
  end

  before_save :strip_whitespace

  def strip_whitespace
    self.name.squish!
  end

  def type_name
    type.blank? ? "Tag" : type
  end

  def self.scope_name
    self.name == "Tag" ? "by_type" : self.name.downcase.pluralize
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

  def self.all_names; self.send(scope_name).map(&:short_names).flatten.map(&:downcase); end

  def self.find_by_short_name(short)
    return nil if short.blank?
    return nil unless self.all_names.include?(short.downcase) # don't catch substring au for audio
    possibles = self.send(scope_name).where(["name LIKE ?", "%" + short.downcase + "%"]).all
    Rails.logger.debug "possibles #{possibles.map(&:name)} from #{short}"
    if possibles.size == 1
      possibles.first
    else
      possibles.find {|p| p.short_names.map(&:downcase).include?(short.downcase)}
    end
  end

  def add_aka(aka_tag)
    all_names = (self.short_names + aka_tag.short_names).uniq
    akas = all_names.without(self.base_name).sort_by(&:downcase).join_comma
    new_name = "#{self.base_name} (#{akas})"
    Rails.logger.debug "merge #{aka_tag.name} into #{self.name} as #{new_name}"
    self.update_attribute(:name, new_name)
    page_ids = aka_tag.pages.map(&:id)
    #TODO this should be able to be done in fewer DB operations
    aka_tag.pages.each {|p| p.tags << self unless p.tags.include?(self)}
    aka_tag.destroy
    self
  end

  def self.names
    self.send(scope_name).by_name.map(&:base_name)
  end

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "destroying #{name} for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
      page.update_tag_cache!
    end
  end

end
