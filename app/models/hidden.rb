class Hidden < Tag
  # Tags to be filtered out by default

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "DEBUG: removing hidden from #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
      if page.tags.hiddens.blank?
        Rails.logger.debug "DEBUG: unsetting hidden for page #{id}"
        page.unset_hidden
      else
        Rails.logger.debug "DEBUG: page #{id} still hidden"
      end
    end
  end

end
