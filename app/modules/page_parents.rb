# frozen_string_literal: true

module PageParents
  def add_chapter(url, count = nil, title = PageTitles::TEMP_TITLE)
    raise "Expecting a String, not a #{url.class}" unless url.is_a?(String)

    chapter = Page.find_by(url: url)
    if chapter
      Rails.logger.debug { "chapter already exists, updating #{chapter.title}" }
      if count.blank?
        if chapter.position.present?
          Rails.logger.debug { 'dont change position unless given specifically' }
          count = chapter.position
        else
          count = parts.size + 1
        end
      end
      chapter.update!(position: count, parent_id: id, type: Chapter, title: title)
      chapter.move_tags_up
    else
      count ||= (parts.size + 1)
      Rails.logger.debug { "chapter does not exist, creating #{title}" }
      chapter = Chapter.create!(title: title, url: url, position: count, parent_id: id)
      if (count % 3).zero?
        Rails.logger.debug { "sleeping after every third created chapter; current count: #{count.ordinalize}" }
        sleep 5
      end
    end
    set_type(reset: true)
    chapter
  end

  def add_part(part_url)
    if ao3? && type == 'Book'
      Rails.logger.debug { 'using add_chapter' }
      add_chapter(part_url) and return
    end
    position = if parts.any?
                 parts.last.position + 1
               else
                 1
               end
    if part_url.blank?
      title = "Part #{position}"
      page = Page.create!(title: title, parent_id: id, position: position)
      page.set_type
    else
      page = Page.find_by(url: part_url)
      if page.blank?
        title = "Part #{position}"
        page = Page.create!(url: part_url, title: title, parent_id: id, position: position)
        page.initial_fetch
        update_attribute(:read_after, Time.zone.now) if read_after > Time.zone.now
        page.set_wordcount
      else
        Rails.logger.debug { "found #{page.inspect}" }
        page.update!(position: position, parent_id: id)
      end
    end
    set_type(reset: true)
    update_from_parts
  end

  def parts_from_urls(url_title_list, refetch: false)
    Rails.logger.debug { "#{'re' if refetch}fetch parts from urls: #{url_title_list}" }
    old_part_ids = parts.map(&:id)
    Rails.logger.debug { "my old parts #{old_part_ids}" }

    new_part_ids = []

    lines = url_title_list.split(/[\r\n]/).select(&:chomp).map(&:squish) - ['']

    parts_with_subparts = lines.select { |l| l.match('^##') }

    parts = if parts_with_subparts.blank?
              lines.reject { |l| l.match('^#') }
            else
              lines.select { |l| l.match('##') }
            end

    if parts.include?(url)
      errors.add(:url_list, 'can’t include your own url')
      return false
    end

    Rails.logger.debug { "find or create parts #{parts}" }
    parts.each do |part|
      title = nil
      url = part.sub(/#.*/, '')
      title = part.sub(/.*#/, '') if part.match?('#')
      position = parts.index(part) + 1
      Rails.logger.debug { "looking for url: #{url} and title: #{title} in position #{position}" }
      page =
        if url.present?
          Page.find_by(url: url)
        else
          possible = Page.find_by(title: title, parent_id: id)
          possibles = Page.where(title: title)
          possible || possibles.first
        end
      if page.blank?
        type = case self.type
               when 'Book'
                 'Chapter'
               when 'Series'
                 'Single'
               else
                 raise "I dont know what kind of parts a #{self.type} should have"
               end
        title = "Part #{position}" if title.blank?
        Rails.logger.debug { "didn't find #{part}" }
        page = Page.create!(url: url, title: title, parent_id: id, position: position, type: type)
        page.initial_fetch
        Rails.logger.debug { "  with errors #{page.errors.messages}" }
        errors.merge!(page.errors)
        Rails.logger.debug { "  so my errors are now  #{errors.messages}" }
        return false if errors.present?

        update_attribute(:read_after, Time.zone.now) if read_after > Time.zone.now
        page.set_wordcount
      else
        Rails.logger.debug { "found #{part.inspect}" }
        if page.url == url
          page.fetch_raw if refetch
        elsif url.present?
          page.update!(:url, url)
          page.fetch_raw
        end
        page.update!(position: position) if page.position != position
        page.update!(parent_id: id) if page.parent_id != id
        page.update!(title: title) if title && page.title != title
      end
      new_part_ids << page.id
    end
    Rails.logger.debug { "parts found or created: #{new_part_ids}" }

    remove = old_part_ids - new_part_ids
    Rails.logger.debug { "removing deleted parts #{remove}" }
    remove.each do |old_part_id|
      Page.find(old_part_id).make_single
    end

    update_from_parts
    set_type(reset: true)
  end

  def add_parent_with_id(parent_id)
    parent = Page.find(parent_id)
    Rails.logger.debug { "adding #{type} with title #{title} to #{parent.type} with title #{parent.title}" }
    count = parent.parts.size + 1
    update!(parent_id: parent.id, position: count)
    if type == 'Single' && %w[Single Book].include?(parent.type)
      Rails.logger.debug 'making me a chapter'
      update!(type: Chapter, notes: '') && parent.update!(type: Book)
      move_tags_up
    else
      parent.update_tag_caches
    end
    parent.update_from_parts
    parent.set_meta
    position
  end
end
