# frozen_string_literal: true

class Author < Tag
  def destroy_me
    page_ids = pages.map(&:id)
    name = self.name
    Rails.logger.debug { "moving author to note for #{page_ids.size} pages" }
    destroy
    page_ids.each do |id|
      page = Page.find(id)
      if page.can_have_tags?
        Rails.logger.debug { "moving author to note for page #{id}" }
        page.add_authors_to_notes([name])
      end
      page.save! # update_tag_cache && reset_boolean
    end
  end
end
