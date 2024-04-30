class Reader < Tag

  def self.recache_all
    self.all.each do |tag|
      tag.pages.update_all reader: true
    end
  end

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "moving reader to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
      Rails.logger.debug "moving reader to note for page #{id}"
      page.add_reader_to_my_notes(name)
      if page.tags.readers.blank?
        Rails.logger.debug "unsetting reader for page #{id}"
        page.unset_reader
      else
        Rails.logger.debug "page #{id} still has reader"
      end
      page.update_tag_cache!
    end
  end

end
