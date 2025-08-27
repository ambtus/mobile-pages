# encoding=utf-8
# frozen_string_literal: true

class Book < Page
  def add_chapter(url, count = nil, title = nil)
    chapter = Page.find_by(url: url)
    if chapter
      count ||= chapter.position
      title ||= chapter.title
      if chapter.position == count && chapter.parent_id == id && chapter.type == 'Chapter' && chapter.title == title
        Rails.logger.debug { "chapter already exists, skipping #{chapter.title}" }
      else
        Rails.logger.debug { "chapter already exists, updating #{chapter.title}" }
        chapter.update(position: count, parent_id: id, type: Chapter, title: title)
      end
    else
      count ||= (parts.size + 1)
      title ||= 'temp'
      Rails.logger.debug { "chapter does not exist, creating #{title} in position #{count}" }
      Chapter.create(title: title, url: url, position: count, parent_id: id)
    end
  end

  def fetch_ao3
    Rails.logger.debug { "fetch_ao3 book #{id}" }
    get_chapters_from_ao3 && set_meta && update_from_parts
  end

  def make_single?(size)
    return false unless size == 1

    Rails.logger.debug 'only one chapter'
    becomes!(Single).fetch_ao3
    true
  end

  def get_chapters_from_ao3(refetch = false)
    Rails.logger.debug { "getting chapters from ao3 for #{id}" }
    html = if refetch || raw_html.blank?
             scrub_fetch("#{url}/navigate")
           else
             raw_html
           end
    return false if html.blank?

    doc = Nokogiri::HTML(html)
    chapter_list = doc.xpath('//ol//a')
    Rails.logger.debug { "chapter list for #{id}: #{chapter_list}" }
    if make_single?(chapter_list.size)
      Rails.logger.debug { "I am now a #{type}" }
      return false
    else
      chapter_list.each_with_index do |element, index|
        count = index + 1
        url = "https://archiveofourown.org#{element['href']}"
        title = element.text.gsub(/^\d*\. /, '')
        add_chapter(url, count, title)
        sleep 5 unless count == chapter_list.size
      end
    end
    true
  end
end
