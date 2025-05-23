class Reader < Tag

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "moving reader to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
      Rails.logger.debug "moving reader to my note for page #{id}"
      page.add_reader_to_my_notes(name)
      page.save! # update_tag_cache && reset_boolean
    end
  end

end
