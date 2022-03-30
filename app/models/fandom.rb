class Fandom < Tag

  def self.names
    self.by_name.map(&:name)
  end

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "DEBUG: moving fandom to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      Rails.logger.debug "DEBUG: moving fandom to note for page #{id}"
      page = Page.find(id)
      page.add_fandom(name).save!
      page.toggle_other_fandom unless page.other_fandom_present?
      page.cache_tags
    end
  end

end
