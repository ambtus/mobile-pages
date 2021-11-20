# encoding=utf-8

class Chapter < Page

  def ao3_chapter_title(doc, position)
    chapter_title = doc.css(".chapter .title").children.last.text.strip rescue nil
    if chapter_title.blank?
      "Chapter #{position}"
    else
      chapter_title.gsub(/^: /,"")
    end
  end

  def get_meta_from_ao3(refetch=true)
    if refetch
      Rails.logger.debug "DEBUG: fetching meta from ao3 for #{self.url}"
      doc = Nokogiri::HTML(Scrub.fetch_html(self.url))
    else
      Rails.logger.debug "DEBUG: build meta from raw html for #{self.id}"
      doc = Nokogiri::HTML(raw_html)
    end

    Rails.logger.debug "DEBUG: getting chapter title for #{self.id} at position #{position}"
    self.title = ao3_chapter_title(doc, position)

    doc_summary = Scrub.sanitize_html(doc.css(".summary blockquote")).children.to_html
    doc_notes = Scrub.sanitize_html(doc.css(".notes blockquote")).children.to_html
    doc_relationships = doc.css(".relationship a").map(&:text).join(", ")  rescue nil
    doc_tags = doc.css(".freeform a").map(&:text).join(", ")  rescue nil

    if position == 1
      self.notes = doc_notes
    else
      self.notes = [doc_summary, doc_notes].join_hr
    end

    self.save
  end

  def fetch_ao3
    Rails.logger.debug "DEBUG: fetch_ao3 chapter #{self.id}"
    self.fetch_raw && set_wordcount && get_meta_from_ao3(false)
  end


end
