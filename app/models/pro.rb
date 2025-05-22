class Pro < Tag
  # Tags to be filtered in
  def self.recache_all
    self.all.each do |tag|
      tag.pages.update_all pro: true
    end
  end

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "removing pro #{name} from #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      page = Page.find(id)
      if page.tags.pros.blank?
        Rails.logger.debug "unsetting pro for page #{id}"
        page.unset_pro
      else
        Rails.logger.debug "page #{id} still has pros"
      end
      page.save!
    end
  end


end
