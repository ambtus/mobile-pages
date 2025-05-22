class Hidden < Tag
  # Tags to be filtered out by default
  def self.recache_all
    self.all.each do |tag|
      tag.pages.update_all hidden: true
    end
  end

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
      page.save!
    end
  end

end
