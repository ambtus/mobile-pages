class Fandom < Tag

  def self.names
    self.by_name.map(&:name)
  end

  def destroy_me
    pages = self.pages
    Rails.logger.debug "DEBUG: moving fandom to OTHER for #{pages.size} pages"
    pages.each do |page|
      Rails.logger.debug "DEBUG: moving fandom to OTHER for page #{id}"
      page.tags << page.other_fandom_tag
      Rails.logger.debug "DEBUG: new fandoms tags for page #{id}: #{page.fandoms}"
    end
    super
  end

end
