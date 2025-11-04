# frozen_string_literal: true

class Reader < Tag
  def self.model_name = Tag.model_name

  def destroy_me
    page_ids = pages.map(&:id)
    name = self.name
    Rails.logger.debug { "moving reader to note for #{page_ids.size} pages" }
    destroy
    page_ids.each do |id|
      page = Page.find(id)
      Rails.logger.debug { "moving reader to my note for page #{id}" }
      page.add_reader_to_my_notes(name)
      page.update_tag_caches
    end
  end
end
