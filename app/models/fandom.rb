class Fandom < Tag

  def destroy_me
    page_ids = self.pages.map(&:id)
    name = self.name
    Rails.logger.debug "moving fandom to note for #{page_ids.size} pages"
    self.destroy
    page_ids.each do |id|
      Rails.logger.debug "moving fandom to note for page #{id}"
      Page.find(id).add_fandoms_to_notes([name]).set_of
    end
  end

end
