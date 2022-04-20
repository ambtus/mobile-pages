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
    self.update title: ao3_chapter_title(doc, position)
    Rails.logger.debug "DEBUG: ao3 chapter title: #{self.title}"

    doc_summary = Scrub.sanitize_html(doc.css(".summary blockquote")).children.to_html
    doc_notes = Scrub.sanitize_html(doc.css(".notes blockquote")).children.to_html

    new_notes =
      if position == 1
        if self.parent.ao3?
          ""
        else
          doc_notes
        end
      else
        [doc_summary, doc_notes].join_hr
    end
    Rails.logger.debug "DEBUG: new notes: #{new_notes}"
    self.update notes: new_notes
    return self
  end

  def fetch_ao3
    Rails.logger.debug "DEBUG: fetch_ao3 chapter #{self.id}"
    fetch_raw && get_meta_from_ao3(false) && cleanup
  end

  def my_fandoms
    doc = Nokogiri::HTML(raw_html)
    doc.css(".fandom a").map(&:children).map(&:text)
  end

  def my_tags
    doc = Nokogiri::HTML(raw_html)
    doc.css(".freeform a").map(&:children).map(&:text)
  end

end
