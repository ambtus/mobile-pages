# encoding=utf-8

class Single < Page

  def fetch_ao3
    Rails.logger.debug "fetch_ao3 single #{self.id}"
    fetch_raw && set_meta
  end

  def make_me_a_chapter
    html = scrub_fetch(self.url + "/navigate")
    return false unless html
    doc = Nokogiri::HTML(html)
    chapter_list = doc.xpath("//ol//a")
    if chapter_list.size == 1
      Rails.logger.debug "still only one chapter"
      return false
    end
    chapter_url = "https://archiveofourown.org" + doc.xpath("//ol//a").first['href']
    Rails.logger.debug "making #{self.id} into a chapter with #{chapter_url}"
    update!(url: chapter_url, position: 1, type: Chapter, title: "temp")
  end

end
