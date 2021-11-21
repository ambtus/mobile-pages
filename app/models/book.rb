# encoding=utf-8

class Book < Page

  def get_meta_from_ao3(refetch=true)
    if refetch
      Rails.logger.debug "DEBUG: fetching meta from ao3 for #{self.url}"
      doc = Nokogiri::HTML(Scrub.fetch_html(self.url))
    elsif make_single?(parts.size)
      Rails.logger.debug "DEBUG: not getting meta for Book because was made Single"
      return false
    else
      Rails.logger.debug "DEBUG: build meta from raw html of first part #{parts.first.id}"
      doc = Nokogiri::HTML(parts.first.raw_html)
    end

    self.title = doc.xpath("//div[@id='workskin']").xpath("//h2").first.children.text.strip rescue "empty title"

    doc_summary = Scrub.sanitize_html(doc.css(".summary blockquote")).children.to_html
    doc_notes = Scrub.sanitize_html(doc.css(".notes blockquote")).children.to_html
    doc_relationships = doc.css(".relationship a").map(&:text).join(", ")  rescue nil
    doc_tags = doc.css(".freeform a").map(&:text).join(", ")  rescue nil

    self.notes = [doc_summary, doc_tags, doc_relationships].join_hr

    # don't add authors for books in a series
    unless self.parent
      add_author(doc.css(".byline a").map(&:text).join(", "))
    end

    self.save
  end

  def get_chapters_from_ao3
    Rails.logger.debug "DEBUG: getting chapters from ao3 for #{self.id}"
    doc = Nokogiri::HTML(Scrub.fetch_html(self.url + "/navigate"))
    chapter_list = doc.xpath("//ol//a")
    Rails.logger.debug "DEBUG: chapter list for #{self.id}: #{chapter_list}"
    if make_single?(chapter_list.size)
      return false
    else
      count = 1
      chapter_list.each do |element|
        title = element.text
        url = "https://archiveofourown.org" + element['href']
        chapter = Chapter.find_by(url: url) || Chapter.find_by(url: "http://archiveofourown.org" + element['href'])
        if chapter
          if chapter.position == count && chapter.parent_id == self.id
            Rails.logger.debug "DEBUG: chapter already exists, skipping #{chapter.id} in position #{count}"
          else
            Rails.logger.debug "DEBUG: chapter already exists, updating #{chapter.id} with position #{count}"
            chapter.update(position: count, parent_id: self.id)
          end
        else
          Rails.logger.debug "DEBUG: chapter does not yet exist, creating #{title} in position #{count}"
          Chapter.create(:title => title, :url => url, :position => count, :parent_id => self.id)
        end
        count = count.next
        sleep 5
      end
    end
    set_wordcount
  end

  def fetch_ao3
    Rails.logger.debug "DEBUG: fetch_ao3 work #{self.id}"
    self.get_chapters_from_ao3 && get_meta_from_ao3(false)
    return self
  end

  def make_single?(size)
    if size == 1 || size == 0
      Rails.logger.debug "DEBUG: only one chapter"
      page = self.becomes!(Single)
      Rails.logger.debug "DEBUG: page became #{page.type}"
      page.fetch_ao3
      return true
    else
      return false
    end
  end
end
