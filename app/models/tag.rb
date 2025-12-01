# frozen_string_literal: true

class Tag < ApplicationRecord
  Module.constants.map(&:name).each do |x|
    next unless x.start_with?('Tag')
    next if %w[Tag TagsController].include? x

    include Module.const_get(x)
  end

  NEW_PLACEHOLDER = 'Enter Tags to add (comma separated)'

  has_and_belongs_to_many :pages, -> { distinct }
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :type }

  before_validation :remove_placeholder

  class << self
    def types = %w[Fandom Author Pro Con Hidden Reader Info Collection]
    def boolean_types = %w[Fandom Author Pro Con Hidden Reader]
    def some_types = types - %w[Fandom Author]
    def title_types = some_types - %w[Info Collection]

    def recache_all
      return unless boolean_types.include?(name)

      Page.update_all(name.downcase => false)
      find_each do |tag|
        tag.pages.update_all(name.downcase => true)
      end
    end

    def with_pages_count
      ary = []
      all.collect { |t| ary << [t.pages.count, t] }
      ary.sort.reverse
    end

    def scope_name
      name == 'Tag' ? 'by_type' : name.downcase.pluralize
    end

    def all_names = send(scope_name).map(&:short_names).flatten.map(&:downcase)

    def names
      send(scope_name).by_name.map(&:base_name)
    end

    def with_short_name(short)
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
  end

  scope :by_name, -> { order('tags.name asc') }
  scope :by_type, -> { order('tags.type desc') }
  scope :some, -> { not_author.not_fandom }
  scope :title_suffixes, -> { where(type: Tag.title_types) }
  types.each do |type|
    scope type.downcase.pluralize.to_sym, -> { where(type: type) }
    scope :"not_#{type.downcase}", -> { where.not(type: type) }
  end
  # NOTE: returns an array, not a scope
  scope :joined, -> { map(&:base_name).join_comma }

  def type_path = "/#{self.class.name.pluralize.downcase}"

  def type_name = type.presence || 'Tag'

  def destroy_me
    page_ids = pages.map(&:id)
    name = self.name
    Rails.logger.debug { "destroying #{name} for #{page_ids.size} pages" }
    destroy
    page_ids.each do |id|
      page = Page.find(id)
      page.update_tag_caches
    end
  end

  private

  def remove_placeholder = name.gsub(NEW_PLACEHOLDER, '').squish!
end
