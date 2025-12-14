# frozen_string_literal: true

module PageTitles
  TEMP_TITLE = 'xyzzy'

  def title_prefix
    if parent
      title.match(position.to_s) ? '' : "#{position}. "
    else
      ''
    end
  end

  def parent_title_prefix = parent&.parent ? "#{parent.position}." : ''
  def gparent_title_prefix = parent&.parent&.parent ? "#{parent.parent.position}." : ''

  def add_parent(string)
    normalized = string.normalize
    parent = nil
    if normalized.present?
      parent = Page.find_by(url: normalized)
      Rails.logger.debug { "finding page by url: #{normalized}" }
    else
      parent = Page.find_by(title: string)
      Rails.logger.debug { "finding page by title: #{string}" }
    end
    if parent.is_a?(Page)
      if parent.has_content?
        Rails.logger.debug 'page has content and cannot be a parent'
        return 'content'
      else
        Rails.logger.debug 'page can be a parent'
      end
    elsif normalized.present?
      Rails.logger.debug 'cannot make a parent with url as title'
      return 'normalized'
    else
      potentials = Page.where(['Lower(title) LIKE ?', "%#{string.downcase}%"]).with_parts
      if potentials.size > 1
        Rails.logger.debug { "#{potentials.size} possible parents found" }
        return potentials.to_a
      elsif potentials.empty?
        Rails.logger.debug 'creating a new parent'
        parent = Page.create!(title: string)
        parent.update! type: parent_type(type)
      else
        Rails.logger.debug { "matching parent found #{potentials.first.title}" }
        parent = potentials.first
        parent.update! type: parent_type(parent.type)
      end
    end
    add_parent_with_id(parent.id)
    Page.find(parent.id)
  end
end
