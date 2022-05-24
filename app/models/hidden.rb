class Hidden < Tag
  # Tags to be filtered out by default

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "removing hidden from #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
      if page.tags.hiddens.blank?
        Rails.logger.debug "unsetting hidden for page #{id}"
        page.unset_hidden
      else
        Rails.logger.debug "page #{id} still hidden"
      end
    end
  end

end
