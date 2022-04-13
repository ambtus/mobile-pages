class Author < Tag

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "DEBUG: moving author to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      Rails.logger.debug "DEBUG: moving author to note for page #{id}"
      page = Page.find(id)
      page.add_author(name)
    end
  end

end
