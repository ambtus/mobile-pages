# frozen_string_literal: true

module PageTags
  TT = 'Time Travel'
  FI = 'Fix-it'

  def tt_tag = Pro.find_or_create_by(name: TT)
  def tt_present? = tags.pros.include?(tt_tag)

  def set_tt
    return if tt_present?

    tags.append(tt_tag)
  end

  def fi_tag = Pro.find_or_create_by(name: FI)
  def fi_present? = tags.pros.include?(fi_tag)

  def set_fi
    return if fi_present?

    tags.append(fi_tag)
  end

  ## if it's a chapter, add the book's authors and fandoms
  ## if it's a series, add its children's authors and fandoms
  def author_tags(add_parent: true)
    mine = tags.authors
    my_parents = parent && add_parent ? parent.author_tags : []
    my_childrens = parts.blank? ? [] : some_parts.map { |p| p.author_tags(add_parent: false) }
    (mine + my_parents + my_childrens).pulverize.sort_by(&:base_name)
  end

  def fandom_tags(add_parent: true)
    mine = tags.fandoms
    my_parents = parent && add_parent ? parent.fandom_tags : []
    my_childrens = parts.blank? ? [] : some_parts.map { |p| p.fandom_tags(add_parent: false) }
    (mine + my_parents + my_childrens).pulverize.sort_by(&:base_name)
  end

  Tag.some_types.each do |type|
    define_method "#{type.downcase}_tags" do
      tags.send(type.downcase.pluralize).sort_by(&:base_name)
    end
  end
  def add_tags_from_string(string, type = 'Tag')
    return if string.blank?

    Rails.logger.debug { "adding #{type} #{string}" }
    string.split(',').each do |try|
      name = try.squish
      exists = Tag.with_short_name(name)
      if exists
        if exists.type == type
          tags << exists unless tags.include?(exists)
        else
          Rails.logger.debug { "Tag #{exists} already exists" }
          errors.add(:base, 'duplicate short name')
          return false
        end
      else
        typed_tag = type.constantize.find_or_create_by(name: name.squish)
        tags << typed_tag unless tags.include?(typed_tag)
      end
    end
    update_tag_caches
    Rails.logger.debug { "tags now #{tags.joined}" }
  end
end
