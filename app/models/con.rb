class Con < Tag
  # Tags to be filtered out

  def self.recache_all
    self.all.each do |tag|
      tag.pages.update_all con: true
    end
  end

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "removing con #{name} from #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
      if page.tags.cons.blank?
        Rails.logger.debug "unsetting con for page #{id}"
        page.unset_con
      else
        Rails.logger.debug "page #{id} still has cons"
      end
      page.update_tag_cache!
    end
  end

end
