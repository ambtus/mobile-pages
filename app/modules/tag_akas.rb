module TagAkas
  def add_aka(aka_tag)
    all_names = (short_names + aka_tag.short_names).uniq
    akas = all_names.without(base_name).sort_by(&:downcase).join_comma
    new_name = "#{base_name} (#{akas})"
    Rails.logger.debug { "merge #{aka_tag.name} into #{name} as #{new_name}" }
    update_attribute(:name, new_name)
    modified_pages = aka_tag.pages
    Rails.logger.debug { "modifying pages with old tag: #{modified_pages.map(&:id)}" }
    # TODO: this should be able to be done in fewer DB operations
    modified_pages.each do |p|
      p.tags << self unless p.tags.include?(self)
      p.tags.delete(aka_tag)
      p.update_tag_caches
    end
    aka_tag.destroy
    self
  end
end
