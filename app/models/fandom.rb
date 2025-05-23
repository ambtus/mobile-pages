class Fandom < Tag

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "moving fandom to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
        if page.can_have_tags?
          Rails.logger.debug "moving fandom to note for page #{id}"
          page.add_fandoms_to_notes([name])
        end
      page.save! # update_tag_cache && reset_boolean
    end
  end

end
