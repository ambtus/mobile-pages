# encoding=utf-8

class Single < Page

  def fetch_ao3
    Rails.logger.debug "DEBUG: fetch_ao3 single #{self.id}"
    fetch_raw && set_meta
  end

  def make_me_a_chapter(parent)
    html = scrub_fetch(self.url + "/navigate")
    return false unless html
    doc = Nokogiri::HTML(html)
    chapter_url = "https://archiveofourown.org" + doc.xpath("//ol//a").first['href']
    Rails.logger.debug "DEBUG: making #{self.id} into a chapter of #{parent.id} with #{chapter_url}"
    update!(url: chapter_url, parent_id: parent.id, position: 1, type: Chapter)
  end

end
