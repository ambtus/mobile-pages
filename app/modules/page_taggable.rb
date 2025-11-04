# frozen_string_literal: true

module PageTaggable
  def can_have_tags? = %w[Single Book].include?(type) || type.blank?
  def tag_types = can_have_tags? ? Tag.types : Tag.some_types

  def cached_tags = Tag.all.select { |t| tag_cache.split_comma.include?(t.base_name) }

  def shared_tags = tags.authors + tags.fandoms

  def update_tag_caches
    Rails.logger.debug { "caching tags for #{id} current: #{tag_cache}" }
    bt = base_tags
    Rails.logger.debug { "  with #{bt}" }
    self.tag_cache = bt
    Tag.boolean_types.each do |thing|
      send("#{thing.downcase}=", tags.where(type: thing).present?)
    end
    save!
    parent&.update_tag_caches
  end

  def base_tags
    case type
    when 'Chapter', 'Single', 'Book'
      tags.map(&:base_name).join_comma
    when 'Series'
      (tags + some_parts.map(&:shared_tags)).pulverize.map(&:base_name).join_comma
    else # shouldn't get here, but...
      Rails.logger.debug { "page #{id} doesn't have a proper type" }
      ''
    end
  end

  # only used when make_me_a_chapter
  def move_tags_up
    return if parent.blank?

    Rails.logger.debug 'moving tags to parent'
    parent.tags << (tags - tags.readers)
    self.tags = tags.readers
    update_tag_caches
  end
end
