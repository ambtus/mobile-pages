# frozen_string_literal: true

module PageParts
  def all_previous = Page.order(:position).where(parent_id: parent_id).where(position: ...position)

  def next_part
    return nil unless parent

    my_index = parent.parts.find_index(self)
    return nil if my_index.nil?

    if parent.parts[my_index + 1]
      parent.parts[my_index + 1]
    elsif parent.next_part
      return parent.next_part if parent.next_part.parts.blank?

      parent.next_part.parts.first

    end
  end

  def previous_part
    return nil unless parent

    my_index = parent.parts.find_index(self)
    return nil if my_index.nil?
    return nil if my_index.zero?

    if parent.parts[my_index - 1]
      parent.parts[my_index - 1]
    elsif parent.previous_part
      return parent.previous_part if parent.previous_part.parts.blank?

      parent.previous_part.parts.last

    end
  end

  def last_chapter?
    return false unless parent

    parent.parts.last == self
  end
end
