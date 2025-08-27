# frozen_string_literal: true

class Tag < ApplicationRecord
  NEW_PLACEHOLDER = 'Enter Tags to add (comma separated)'

  has_and_belongs_to_many :pages, -> { distinct }
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :type }

  before_validation :fixme
  def fixme = name.gsub(NEW_PLACEHOLDER, '').squish!

  def self.types = %w[Fandom Author Pro Con Hidden Reader Info Collection]
  def self.boolean_types = %w[Fandom Author Pro Con Hidden Reader]
  def self.some_types = types - %w[Fandom Author]
  def self.title_types = some_types - %w[Info Collection]

  def self.recache_all
    return unless boolean_types.include?(name)

    Page.update_all(name.downcase => false)
    find_each do |tag|
      tag.pages.update_all(name.downcase => true)
    end
  end

  scope :by_name, -> { order('tags.name asc') }
  scope :by_type, -> { order('tags.type desc') }

  def self.with_pages_count
    ary = []
    all.collect { |t| ary << [t.pages.count, t] }
    ary.sort.reverse
  end

  scope :title_suffixes, -> { where(type: Tag.title_types) }

  types.each do |type|
    scope type.downcase.pluralize.to_sym, -> { where(type: type) }
    scope :"not_#{type.downcase}", -> { where.not(type: type) }
  end

  scope :some, -> { not_author.not_fandom }

  # NOTE: this must go at the end, because it returns an array, not a scope
  scope :joined, -> { map(&:base_name).join_comma }

  def type_name = type.presence || 'Tag'

  def self.scope_name
    name == 'Tag' ? 'by_type' : name.downcase.pluralize
  end

  def short_names
    if name =~ /([^\(]*) \((.*)\)/
      true_name = ::Regexp.last_match(1)
      aka_string = ::Regexp.last_match(2)
      akas = aka_string.split(', ')
      [true_name, *akas]
    else
      [name]
    end
  end

  def base_name = short_names.first

  def self.all_names = send(scope_name).map(&:short_names).flatten.map(&:downcase)

  def self.with_short_name(short)
    return nil if short.blank?
    return nil unless all_names.include?(short.downcase) # don't catch substring au for audio

    possibles = send(scope_name).where(['name LIKE ?', "%#{short.downcase}%"]).all
    Rails.logger.debug { "possibles #{possibles.map(&:name)} from #{short}" }
    if possibles.size == 1
      possibles.first
    else
      possibles.find { |p| p.short_names.map(&:downcase).include?(short.downcase) }
    end
  end

  def add_aka(aka_tag)
    all_names = (short_names + aka_tag.short_names).uniq
    akas = all_names.without(base_name).sort_by(&:downcase).join_comma
    new_name = "#{base_name} (#{akas})"
    Rails.logger.debug { "merge #{aka_tag.name} into #{name} as #{new_name}" }
    update_attribute(:name, new_name)
    aka_tag.pages.map(&:id)
    # TODO: this should be able to be done in fewer DB operations
    aka_tag.pages.each { |p| (p.tags << self) && p.save! unless p.tags.include?(self) }
    aka_tag.destroy
    self
  end

  def self.names
    send(scope_name).by_name.map(&:base_name)
  end

  def destroy_me
    page_ids = pages.map(&:id)
    name = self.name
    Rails.logger.debug { "destroying #{name} for #{page_ids.size} pages" }
    destroy
    page_ids.each do |id|
      page = Page.find(id)
      page.save! # update_tag_cache && reset_boolean
    end
  end
end
