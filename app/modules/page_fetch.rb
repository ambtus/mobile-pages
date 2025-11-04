# frozen_string_literal: true

module PageFetch
  def fetch_by_url
    Rails.logger.debug { "  for url #{url}" }
    ao3? ? fetch_ao3 : fetch_raw
  end

  def fetch_by_pattern
    Rails.logger.debug { "  for base_url #{base_url}" }
    update! type: Book
    self.url = base_url.delete('*') if base_url.match?(/fanfiction.net/)
    match = url_substitutions.match('-')
    array = if match
              match.pre_match.to_i..match.post_match.to_i
            else
              url_substitutions.split
            end
    count = 1
    array.each do |sub|
      url = base_url.gsub('*', sub.to_s)
      chapter = Page.find_by url: url
      if chapter
        chapter.update!(position: count, parent_id: id)
        Rails.logger.debug { "found #{chapter.inspect}" }
      else
        title = "Part #{count}"
        Rails.logger.debug { "creating new chapter with title: #{title}" }
        chapter = Chapter.create!(title: title, url: url, position: count, parent_id: id)
        chapter.initial_fetch
        Rails.logger.debug { "  with errors #{chapter.errors.messages}" }
        errors.merge!(chapter.errors)
        Rails.logger.debug { "  so my errors are now  #{errors.messages}" }
      end
      count = count.next
    end
  end

  def fetch_by_urls
    Rails.logger.debug { "  for multiple urls #{urls}" }
    update! type: Book
    parts_from_urls(urls)
  end

  def refetch_recursive
    parts.each(&:refetch_recursive)
    fetch_raw && set_meta
  end
end
