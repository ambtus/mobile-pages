# frozen_string_literal: true

module PageTypes
  def type_should_be
    if parts.empty?
      parent_id.nil? ? Single : Chapter
    else
      part_types = parts.map(&:type).uniq.compact
      Rails.logger.debug { "part types: #{part_types}" }
      if (part_types - ['Chapter']).empty?
        Book
      else
        Series
      end
    end
  end

  def make_single
    Rails.logger.debug { "removing #{id} from #{parent_id}" }
    raise 'cannot remove from nothing' unless parent

    parent_tags = parent.tags
    update(parent_id: nil, position: nil)
    update(type: 'Single') if type == 'Chapter'
    tags << (parent_tags - tags)
    update_tag_caches
    rebuild_meta
  end

  def parent_type(childs_type)
    case childs_type
    when 'Chapter', nil
      Book
    when 'Single'
      ao3? ? 'Series' : 'Book'
    else
      Series
    end
  end

  def increase_type
    new = case type
          when nil, 'Chapter'
            'Single'
          when 'Single'
            'Book'
          when 'Book'
            'Series'
          else
            raise 'cannot increase type'
          end
    update type: new
    return unless new == 'Single' && parent&.type == 'Book'

    parent.increase_type
    parent.parts.where(type: 'Chapter').map(&:increase_type)
  end

  def decrease_type
    new = case type
          when 'Series'
            'Book'
          when 'Book'
            'Single'
          when 'Single'
            'Chapter'
          else
            raise 'cannot decrease type'
          end
    update type: new
    parts.map(&:decrease_type) if new == 'Book'
  end
end
