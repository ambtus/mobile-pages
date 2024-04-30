class Author < Tag

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "moving author to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
        if page.can_have_tags?
          Rails.logger.debug "moving author to note for page #{id}"
          Page.find(id).add_authors_to_notes([name])
        end
      page.update_tag_cache!
    end
  end

end
