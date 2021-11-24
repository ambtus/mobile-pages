# encoding=utf-8

class Series < Page

  def get_meta_from_ao3(refetch=true)
    Rails.logger.debug "DEBUG: fetch_ao3 series #{self.id}"
    html = Scrub.fetch_html(self.url)
    doc = Nokogiri::HTML(html)

    doc_title = doc.xpath("//div[@id='main']").xpath("//h2").first.children.text.strip rescue nil
    if doc_title
      Rails.logger.debug "DEBUG: found title: #{doc_title}"
      self.title = doc_title
    else
      Rails.logger.debug "DEBUG: was not able to find title"
      self.title = "title not found"
    end

    doc_authors = nil
    doc_summary = nil
    doc_notes = nil
    doc.css('#inner dt').each do |dt|
      ct = dt.xpath('count(following-sibling::dt)')
      # Rails.logger.debug "DEBUG: ct: #{ct.inspect}"
      dds = dt.xpath("following-sibling::dd[count(following-sibling::dt)=#{ct}]")
      # Rails.logger.debug "DEBUG: dds: #{dds.inspect}"
      case dt.text
      when "Creator:"
        doc_authors = dds.map(&:text).join(", ")
        Rails.logger.debug "DEBUG: found authors: #{doc_authors}"
      when "Description:"
        doc_summary = Scrub.sanitize_html(dds.children.children.to_html)
        Rails.logger.debug "DEBUG: found description: #{doc_summary}"
      when "Notes:"
        doc_notes = Scrub.sanitize_html(dds.children.children.to_html)
        Rails.logger.debug "DEBUG: found notes: #{doc_notes}"
      end
    end

    self.notes = [doc_summary, doc_notes].compact.join_hr

    add_author(doc_authors) if doc_authors

    self.save!

    return html.scan(/work-(\d+)/).flatten.uniq

  end

  def fetch_ao3
    work_list = get_meta_from_ao3
    Rails.logger.debug "DEBUG: work list for #{self.id}: #{work_list}"
    work_list.each_with_index do |work_id, index|
      count = index + 1
      url = "https://archiveofourown.org/works/#{work_id}"
      possibles = Page.where("url LIKE ?", "%#{url.sub(/^https?/, '')}%")
      work = possibles.first if possibles.size == 1
      if possibles.size > 1
        possibles.each do |p|
          if p.parent && p.parent.ao3_url == url
           Rails.logger.debug "DEBUG: selecting #{p.parent.title}"
           work = p.parent
           break
          end
        end
      end
      if work
        if work.position == count && work.parent_id == self.id
          Rails.logger.debug "DEBUG: work already exists, skipping #{work.id} in position #{count}"
        else
          Rails.logger.debug "DEBUG: work already exists, updating #{work.id} with position #{count} and parent_id #{self.id}"
          work.update!(position: count, parent_id: self.id)
        end
      else
        Rails.logger.debug "DEBUG: work does not yet exist, creating ao3/works/#{work_id} in position #{count} and parent_id #{self.id}"
        book = Book.new(:url => url, :position => count, :parent_id => self.id)
        # Rails.logger.debug "DEBUG: will create #{book.inspect}"
        book.fetch_ao3
        sleep 5 unless count == work_list.size
      end
    end

    set_wordcount
  end

end
