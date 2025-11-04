# frozen_string_literal: true

class Fandom < Tag
  def self.model_name = Tag.model_name

  def destroy_me
    page_ids = pages.map(&:id)
    name = self.name
    Rails.logger.debug { "moving fandom to note for #{page_ids.size} pages" }
    destroy
    page_ids.each do |id|
      page = Page.find(id)
      if page.can_have_tags?
        Rails.logger.debug { "moving fandom to note for page #{id}" }
        page.add_fandoms_to_notes([name])
      end
      page.update_tag_caches
    end
  end
end
