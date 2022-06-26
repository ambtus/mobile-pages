class Reader < Tag

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "moving reader to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      Rails.logger.debug "moving reader to note for page #{id}"
      Page.find(id).add_reader_to_my_notes(name)
    end
  end

end
