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
    work_title = doc.xpath("//div[@id='workskin']").xpath("//h2").first.children.text.strip rescue "can’t find title"
    self.title = chapter_title.blank? ? work_title : chapter_title

    doc_summary = Scrub.sanitize_html(doc.css(".summary blockquote")).children.to_html
    doc_notes = Scrub.sanitize_html(doc.css(".notes blockquote")).children.to_html
    doc_relationships = doc.css(".relationship a").map(&:text).join(", ")  rescue nil
    doc_tags = doc.css(".freeform a").map(&:text).join(", ")  rescue nil
    self.notes = [doc_summary, doc_notes, doc_tags, doc_relationships].join_hr

    Rails.logger.debug "DEBUG: notes: #{self.notes}"

    # don't add authors for books in a series
    unless self.parent
      add_author(doc.css(".byline a").map(&:text).join(", "))
    end

    self.save!
  end

  def fetch_ao3
    if self.id
      Rails.logger.debug "DEBUG: fetch_ao3 single #{self.id}"
      fetch_raw && set_wordcount && get_meta_from_ao3(false)
    else
      Rails.logger.debug "DEBUG: fetch_ao3 single #{self.url}"
      get_meta_from_ao3 && fetch_raw && set_wordcount
    end
  end

end
