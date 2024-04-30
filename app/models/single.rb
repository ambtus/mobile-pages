# encoding=utf-8

class Single < Page

  def fetch_ao3
    Rails.logger.debug "fetch_ao3 single #{self.id}"
    fetch_raw && set_meta
  end

  def get_chapter_list
    html = scrub_fetch(self.url + "/navigate")
    if html
      doc = Nokogiri::HTML(html)
      doc.xpath("//ol//a")
    else
      Rails.logger.debug "unable to navigate"
      return false
    end
  end

  def chapter_url
    chapter_list = get_chapter_list
    return false unless chapter_list
    if chapter_list.size == 1
      Rails.logger.debug "still only one chapter"
      return false
    else
      chapter_url = "https://archiveofourown.org" + chapter_list.first['href']
      return chapter_url
    end
  end

  def make_me_a_chapter(passed_url)
    old_position = self.position
    if chapter_url
      book = Book.create!(title: "temp")
      Rails.logger.debug "making #{self.id} into a chapter of Book #{book.id} with #{chapter_url}"
      if self.parent
        book.parent_id = self.parent.id
        book.position = self.position
      end
      self.parent_id = book.id
      self.position = 1
      book.url = passed_url
      self.url = chapter_url
      self.type = "Chapter"
      self.title = "temp"
      self.save!
      book.save!
      book.fetch_ao3
      return self
    else
      return false
    end
  end

end
