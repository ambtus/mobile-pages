# encoding=utf-8

class Book < Page

  def get_meta_from_ao3(refetch=true)
    if refetch
      Rails.logger.debug "DEBUG: fetching meta from ao3 for #{self.url}"
      tags_doc = doc = Nokogiri::HTML(Scrub.fetch_html(self.url))
    elsif make_single?(parts.size)
      Rails.logger.debug "DEBUG: not getting meta for Book because was made Single"
      return false
    else
      Rails.logger.debug "DEBUG: build meta from raw html of first and last parts"
      doc = Nokogiri::HTML(parts.first.raw_html)
      tags_doc = Nokogiri::HTML(parts.last.raw_html)
    end

    self.update title: doc.xpath("//div[@id='workskin']").xpath("//h2").first.children.text.strip rescue "empty title"
    Rails.logger.debug "DEBUG: ao3 book title: #{self.title}"

    doc_summary = Scrub.sanitize_html(doc.css(".summary blockquote")).children.to_html
    doc_notes = Scrub.sanitize_html(doc.css(".notes blockquote")).children.to_html
    doc_relationships = tags_doc.css(".relationship a").map(&:text).to_p  rescue nil
    doc_tags = tags_doc.css(".freeform a").map(&:text).to_p rescue nil

    self.update notes: [doc_relationships, doc_summary, doc_tags, doc_notes].join_hr

    add_fandom(my_fandoms.join_comma)
    add_author(doc.css(".byline a").map(&:text).join_comma)

    Rails.logger.debug "DEBUG: notes now: #{self.notes}"

  end

  def my_fandoms
    (parts.first.my_fandoms + parts.second.my_fandoms).uniq
  end

  def get_wip_from_ao3
    Rails.logger.debug "DEBUG: build meta from raw html of last part #{parts.last.id}"
    doc = Nokogiri::HTML(parts.last.raw_html)

    chapters = doc.css(".stats .chapters").children[1].text.split('/') rescue Array.new
    Rails.logger.debug "DEBUG: wip status: #{chapters}"
    wip_switch(chapters.second == "?" || chapters.first != chapters.second)
  end

  def get_chapters_from_ao3
    Rails.logger.debug "DEBUG: getting chapters from ao3 for #{self.id}"
    doc = Nokogiri::HTML(Scrub.fetch_html(self.url + "/navigate"))
    chapter_list = doc.xpath("//ol//a")
    Rails.logger.debug "DEBUG: chapter list for #{self.id}: #{chapter_list}"
    if make_single?(chapter_list.size)
      return false
    else
      chapter_list.each_with_index do |element, index|
        count = index + 1
        title = element.text
        url = "https://archiveofourown.org" + element['href']
        chapter = Chapter.find_by(url: url)
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
          sleep 5 unless count == chapter_list.size
        end
      end
    end
  end

  def fetch_ao3
    if self.id
      Rails.logger.debug "DEBUG: fetch_ao3 work #{self.id}"
      get_chapters_from_ao3 && get_meta_from_ao3(false) && get_wip_from_ao3 && cleanup(false)
    else
      Rails.logger.debug "DEBUG: fetch_ao3 work #{self.url}"
      get_meta_from_ao3 && get_chapters_from_ao3 && get_wip_from_ao3 && cleanup(false)
    end
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
