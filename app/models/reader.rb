class Reader < Tag

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    self.destroy
    Rails.logger.debug "moving reader to my note for #{page_ids.size} pages"
    page_ids.each do |id|
      page = Page.find(id)
      Rails.logger.debug "moving reader to my note for page #{id}"
      page.add_reader_to_my_notes(name)
      page.update_tag_cache!
    end
  end

end
