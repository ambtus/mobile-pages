# frozen_string_literal: true

module PageUrls
  def normalize_url
    return nil if url.blank?

    unless url.is_a?(String)
      errors.add(:url, 'is not a string')
      return nil
    end

    normalized = url.normalize
    if normalized.blank?
      errors.add(:url, 'is invalid')
      return nil
    elsif normalized.match?('archiveofourown.org/users')
      errors.add(:url, 'cannot be ao3 user')
      return nil
    elsif normalized.match('(.*)/collections/(.*)/works/(.*)')
      normalized = "#{::Regexp.last_match(1)}/works/#{::Regexp.last_match(3)}"
    elsif normalized.match?('archiveofourown.org/collections')
      errors.add(:url, 'cannot be an ao3 collection')
      return nil
    end
    self.url = normalized
  end

  def cn? = url&.match(/clairesnook.com/)
  def km? = url&.match(/keiramarcos.com/)
  def wp? = cn? || km?
  def wikipedia? = url&.match(/wikipedia.org/)

  def ao3? = url&.include?('archiveofourown')
  def first_part_ao3? = parts.any? && parts.first.ao3?
  def ao3_chapter? = ao3? && url.include?('chapter')
  def ao3_chapters? = parts.first&.ao3?
  def ao3_work? = ao3? && url.include?('work') && url.exclude?('chapter')
  def not_ao3_series? = ao3? && url.exclude?('series')

  def ff? = url&.match(/fanfiction.net/)
  def ff_chapter? = ff? && ff_chapter_number != '1'
  def ff_chapter_number = url.split('/s/').second.split('/').second
  def first_part_ff? = parts.any? && parts.first.ff?

  def chapter_url? = ao3_chapter? || ff_chapter?
  def chapter_as_single? = type == 'Single' && chapter_url?

  def ao3_type_should_be
    case url
    when /chapters/
      parent ? Chapter : Single
    when /works/
      # if it's a single, will be reset during get_chapters_from_ao3
      Book
    when /series/
      Series
    else
      raise "what's my ao3 type?"
    end
  end

  def fetch_ao3(refetch: true)
    Rails.logger.debug { "fetch_ao3 #{type} #{id}" }
    case type
    when 'Chapter', 'Single'
      fetch_raw if refetch
      set_meta
    when 'Book'
      get_chapters_from_ao3(refetch: refetch)
    when 'Series'
      get_works_from_ao3(refetch: refetch)
    else
      Rails.logger.debug { 'needs a type in order to fetch' }
      errors.add(:url, 'needs a type in order to fetch')
    end
  end

  def get_chapters_from_ao3(refetch: false)
    Rails.logger.debug { "getting chapters from ao3 for #{id} refetch: #{refetch}" }
    nav = refetch ? fetch_navigate : navigate_html
    return if errors.present?

    chapter_list = Nokogiri::HTML(nav).xpath('//ol//a')

    Rails.logger.debug { "chapter list for #{id}: #{chapter_list}" }
    if chapter_list.blank? || chapter_list.size == 1
      Rails.logger.debug 'only one chapter'
      update!(type: Single)
      fetch_raw if refetch
      set_meta
      Rails.logger.debug { "I am now a #{type}: #{inspect}" }
    else
      chapter_list.each_with_index do |element, index|
        count = index + 1
        url = "https://archiveofourown.org#{element['href']}"
        title = element.text.gsub(/^\d*\. /, '')
        chapter = add_chapter(url, count, title)
        chapter.fetch_raw if refetch
        chapter.set_meta if chapter.updated_at > 1.minute.ago
        Rails.logger.debug { "I am now: #{chapter.inspect}" }
      end
      update_from_parts
      set_meta
    end
  end

  def get_works_from_ao3(refetch: false)
    Rails.logger.debug { "getting works from ao3 for #{type} #{id} refetch: #{refetch}" }
    nav = refetch ? fetch_navigate : navigate_html
    return if errors.present?

    work_list = nav.scan(/work-(\d+)/).flatten.uniq
    Rails.logger.debug { "work list for #{id}: #{work_list}" }
    get_ao3_works_from_list(work_list)
    rebuild_meta
    true
  end

  def get_ao3_works_from_list(work_list)
    work_list.each_with_index do |work_id, index|
      count = index + 1
      url = "https://archiveofourown.org/works/#{work_id}"
      work = Page.find_by(url: url)
      if work.nil?
        # do its chapters exist?
        possibles = Page.where('url LIKE ?', "#{url}/chapters/%")
      end
      possibles&.each do |p|
        if p.parent && p.parent == self
          Rails.logger.debug { "selecting from my first level possibles #{p.title}" }
          work = p
          break
        elsif p.parent && p.parent.parent.nil?
          Rails.logger.debug { "selecting from unclaimed first level possibles #{p.parent.title}" }
          work = p.parent
          break
        elsif p.parent && p.parent.parent == self
          Rails.logger.debug { "selecting from my second level possibles #{p.parent.title}" }
          work = p.parent
          break
        elsif p.parent&.parent && p.parent.parent.parent.nil?
          Rails.logger.debug { "selecting from unclaimed second level possibles #{p.parent.parent.title}" }
          work = p.parent.parent
          break
        end
      end
      if work
        if work.position == count && work.parent_id == id
          Rails.logger.debug { "#{work.class} already exists in position #{count}" }
          work.set_type(reset: true)
        else
          Rails.logger.debug do
            "work already exists, updating #{work.title} with position #{count} and parent_id #{id}"
          end
          work.update!(position: count, parent_id: id)
        end
      else
        Rails.logger.debug do
          "work does not yet exist, creating ao3/works/#{work_id} in position #{count} and parent_id #{id}"
        end
        work = Book.create!(url: url, position: count, parent_id: id).set_wordcount
        if index.odd? && index < work_list.size
          Rails.logger.debug { "sleeping between every other work; current count: #{index.ordinalize}" }
          sleep 5
        end
      end
    end
  end

  def get_chapter_list
    html = navigate_fetch("#{url}/navigate")
    if html
      doc = Nokogiri::HTML(html)
      doc.xpath('//ol//a')
    else
      Rails.logger.debug 'unable to navigate'
      false
    end
  end

  def chapter_url
    chapter_list = get_chapter_list
    return false unless chapter_list

    if chapter_list.size == 1
      Rails.logger.debug 'still only one chapter'
      false
    else
      "https://archiveofourown.org#{chapter_list.first['href']}"

    end
  end

  def make_me_a_chapter(passed_url)
    position
    return false unless chapter_url

    book = Book.create!(title: PageTitles::TEMP_TITLE)
    Rails.logger.debug { "making #{id} into a chapter of Book #{book.id} with #{chapter_url}" }
    if parent
      book.parent_id = parent.id
      book.position = position
    end
    self.parent_id = book.id
    self.position = 1
    book.url = passed_url
    self.url = chapter_url
    self.type = 'Chapter'
    self.title = PageTitles::TEMP_TITLE
    save!
    book.save!
    book.fetch_ao3
    self
  end

  # if called from the command line, can pass the new chapter url
  # if called from the web, the chapter has no url until refetched
  def make_me_into_a_chapter(chapter_url = nil)
    book = Book.create!(title: title)
    if parent
      book.parent_id = parent.id
      book.position = position
    end
    self.parent_id = book.id
    self.position = 1
    book.url = url
    self.url = chapter_url
    self.type = 'Chapter'
    self.title = PageTitles::TEMP_TITLE
    save!
    book.save!
    move_tags_up
    move_soon_up
    book.rebuild_meta
  end

  def url_list
    return if parts.blank?

    partregexp = /\APart \d+\Z/
    list = []
    parts.each do |part|
      if part.parts.blank?
        line = part.url
        unless part.title.match(partregexp)
          line ||= ''
          line = "#{line}###{part.title}"
        end
        list << line
      else
        list << "###{part.title}"
      end
    end
    list.join("\n")
  end

  def url_list_length
    return 33 if url_list.blank?

    url_list.split("\n").max_by(&:length).length
  end

  def refetch_url
    return url if ao3?
    return parts.first.url.split('/chapter').first if ao3_chapters?

    url.presence || ''
  end

  def last_url = parts.any? ? parts.last.url : nil
  def last_url_length = last_url ? last_url.length : 33
end
