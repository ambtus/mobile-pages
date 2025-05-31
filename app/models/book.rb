# encoding=utf-8

class Book < Page

  def add_chapter(url, count = parts.size + 1, title = 'temp')
    chapter = Page.find_by(url: url)
    if chapter
      if chapter.position == count && chapter.parent_id == self.id && chapter.type == "Chapter"
        Rails.logger.debug "chapter already exists, skipping #{chapter.title}"
      else
        Rails.logger.debug "chapter already exists, updating #{chapter.title}"
        chapter.update(position: count, parent_id: self.id, type: Chapter)
      end
    else
      Rails.logger.debug "chapter does not exist, creating #{title} in position #{count}"
      Chapter.create(:title => title, :url => url, :position => count, :parent_id => self.id)
    end
  end

  def fetch_ao3
    Rails.logger.debug "fetch_ao3 book #{self.id}"
    get_chapters_from_ao3 && set_meta && update_from_parts
  end

  def make_single?(size)
    if size == 1
      Rails.logger.debug "only one chapter"
      self.becomes!(Single).fetch_ao3
      return true
    else
      return false
    end
  end

  def get_chapters_from_ao3
    Rails.logger.debug "getting chapters from ao3 for #{self.id}"
    html = scrub_fetch(self.url + "/navigate")
    return false unless html
    doc = Nokogiri::HTML(html)
    chapter_list = doc.xpath("//ol//a")
    Rails.logger.debug "chapter list for #{self.id}: #{chapter_list}"
    if make_single?(chapter_list.size)
      Rails.logger.debug "I am now a #{self.type}"
      return false
    else
      chapter_list.each_with_index do |element, index|
        count = index + 1
        title = element.text.gsub(/^\d*\. /,"")
        url = "https://archiveofourown.org" + element['href']
        add_chapter(url)
        sleep 5 unless count == chapter_list.size
      end
    end
    return true
  end

end
