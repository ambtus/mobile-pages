class Reader < Tag

  def self.recache_all
    self.all.each do |tag|
      tag.pages.update_all reader: true
    end
  end

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "removing reader #{name} from #{page_ids.size} pages"
    self.destroy
    Rails.logger.debug "moving reader to my note for #{page_ids.size} pages"
    page_ids.each do |id|
      page = Page.find(id)
      Rails.logger.debug "moving reader to my note for page #{id}"
      page.add_reader_to_my_notes(name)
      if page.tags.readers.blank?
        Rails.logger.debug "unsetting reader for page #{id}"
        page.unset_reader
      else
        Rails.logger.debug "page #{id} still has readers"
      end
      page.save!
    end
  end

end
