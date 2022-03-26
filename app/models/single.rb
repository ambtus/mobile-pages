# encoding=utf-8

class Single < Page

  def get_meta_from_ao3(refetch=true)
    if refetch
      Rails.logger.debug "DEBUG: fetching meta from ao3 for #{self.url}"
      doc = Nokogiri::HTML(Scrub.fetch_html(self.url))
    else
      Rails.logger.debug "DEBUG: build meta from raw html for #{self.id}"
      doc = Nokogiri::HTML(raw_html)
    end

    chapter_title = doc.css(".chapter .title").children.last.text.strip.gsub(": ","") rescue nil
    Rails.logger.debug "DEBUG: ao3 single chapter title: #{chapter_title}"
    work_title = doc.xpath("//div[@id='workskin']").xpath("//h2").first.children.text.strip rescue "can’t find title"
    Rails.logger.debug "DEBUG: ao3 single work title: #{work_title}"
    chapter_title = work_title if chapter_title.blank?
    self.title = ao3_chapter? ? chapter_title : work_title
    Rails.logger.debug "DEBUG: ao3 single title: #{self.title}"

    doc_summary = Scrub.sanitize_html(doc.css(".summary blockquote")).children.to_html
    doc_notes = Scrub.sanitize_html(doc.css(".notes blockquote")).children.to_html
    doc_relationships = doc.css(".relationship a").map(&:text).join(", ")  rescue nil
    doc_tags = doc.css(".freeform a").map(&:text).join(", ")  rescue nil
    self.notes = [doc_summary, doc_notes, doc_tags, doc_relationships].join_hr
    Rails.logger.debug "DEBUG: notes: #{self.notes}"

    if ao3_chapter?
      wip_switch(false)
    else # single chapter work (at least for now)
      chapters = doc.css(".stats .chapters").children[1].text.split('/') rescue Array.new
      Rails.logger.debug "DEBUG: wip status: #{chapters}"
      wip_switch(chapters.second == "?" || chapters.first != chapters.second)
    end

    ao3_authors = doc.css(".byline a").map(&:text).join_comma
    add_author(ao3_authors)
    ao3_fandoms = doc.css(".fandom a").map(&:children).map(&:text).join_comma
    add_fandom(ao3_fandoms)
    Rails.logger.debug "DEBUG: notes now: #{self.notes}"

    self.save!
  end

  def fetch_ao3
    if self.id
      Rails.logger.debug "DEBUG: fetch_ao3 single #{self.id}"
      fetch_raw && get_meta_from_ao3(false) && cleanup
    else
      Rails.logger.debug "DEBUG: fetch_ao3 single #{self.url}"
      get_meta_from_ao3 && fetch_raw && cleanup
    end
  end

  def make_me_a_chapter(parent)
    doc = Nokogiri::HTML(Scrub.fetch_html(self.url + "/navigate"))
    my_info = doc.xpath("//ol//a").first
    chapter_url = "https://archiveofourown.org" + my_info['href']
    Rails.logger.debug "DEBUG: making #{self.title} into a chapter of #{parent.id} with #{chapter_url}"
    update!(url: chapter_url, parent_id: parent.id, position: 1, type: Chapter)
  end

end
