module Meta
  WIP = "WIP"
  TT = "Time Travel"
  OTHER = "Other Fandom"

  def wip_tag; Con.find_or_create_by(name: WIP); end
  def wip_present?; tags.cons.include?(wip_tag);end
  def set_wip; tags.append(wip_tag) unless wip_present?; end
  def toggle_wip
    wip_present? ? tags.delete(wip_tag) : tags.append(wip_tag)
    return self
  end

  def tt_tag; Pro.find_or_create_by(name: TT); end
  def tt_present?; tags.pros.include?(tt_tag);end
  def set_tt; tags.append(tt_tag) unless tt_present?; end
  def toggle_tt
    tt_present? ? tags.delete(tt_tag) : tags.append(tt_tag)
    return self
  end

  def of_tag; Fandom.find_or_create_by(name: OTHER); end
  def of_present?; self.tags.fandoms.include?(of_tag);end
  def set_of; tags.append(of_tag) unless of_present?; end
  def toggle_of
    of_present? ? tags.delete(of_tag) : self.tags.append(of_tag)
    return self
  end

  def doc
    if self.is_a? Book
      Nokogiri::HTML(parts.last.raw_html)
    else
      fetch_raw if raw_html.blank?
      return "" if raw_html.blank?
      Nokogiri::HTML(raw_html)
    end
  end

  def work_doc; self.is_a?(Book) ? Nokogiri::HTML(parts.first.raw_html) : doc; end

  def wip?
    return false if self.is_a? Series # ignore Complete stat on series since it's rarely used
    chapters = doc.css(".stats .chapters").children[1].text.split('/') rescue Array.new
    Rails.logger.debug "DEBUG: wip status: #{chapters}"
    chapters.second == "?" || chapters.first != chapters.second
  end

  def ao3_fandoms
    if self.parts.empty?
      Rails.logger.debug "DEBUG: get fandoms from raw_html"
      doc.css(".fandom a").map(&:children).map(&:text)
    else
      Rails.logger.debug "DEBUG: get fandoms from first and last parts"
      (parts.first.ao3_fandoms + parts.last.ao3_fandoms).uniq
    end
  end

  def ao3_relationships
    if self.parts.empty?
      Rails.logger.debug "DEBUG: get relationships from raw_html"
      doc.css(".relationship a").map(&:children).map(&:text)
    else
      Rails.logger.debug "DEBUG: get relationships from first and last parts"
      (parts.first.ao3_relationships + parts.last.ao3_relationships).uniq
    end
  end

  def ao3_tags
    if self.parts.empty?
      Rails.logger.debug "DEBUG: get tags from raw_html"
      doc.css(".freeform a").map(&:children).map(&:text)
    else
      Rails.logger.debug "DEBUG: get tags from first and last parts"
      (parts.first.ao3_tags + parts.last.ao3_tags).uniq
    end
  end

  def ao3_authors
    if self.is_a? Series
      doc.css(".series dd").first.children.map(&:text).without(", ")
    else
      doc.css(".byline a").map(&:text)
    end
  end

  def chapter_title
    ao3_ch_title = doc.css(".chapter .title").children.last.text.strip.gsub(/^: /,"") rescue nil
  end

  def work_title
    work_doc.xpath("//div[@id='main']").xpath("//h2").first.children.text.strip rescue "title not found"
  end

  def ao3_title
    if self.is_a? Chapter
      chapter_title.blank? ? "Chapter #{position}" : chapter_title
    elsif self.is_a? Single
      if ao3_chapter?
        # A Single with a chapter url gets a chapter title, unless it is empty or Chapter X
        Rails.logger.debug "DEBUG: chapter title: #{chapter_title}, work title: #{work_title}"
        if chapter_title.blank? || chapter_title.match(/^Chapter \d*$/)
          work_title
        else
          chapter_title
        end
      else
        # A Single with a work url gets the work title
        work_title
      end
    else
      work_title
    end
  end

  def ao3_summary
    return "" if self.is_a? Chapter
    if self.is_a? Series
      return work_doc.css(".series dd")[3].children.map(&:text) if doc.css(".series dt")[3].text == "Description:"
      return work_doc.css(".series dd")[4].children.map(&:text) if doc.css(".series dt")[4].text == "Description:"
    else
      Scrub.sanitize_html(work_doc.css(".summary blockquote")).children.to_html
    end
  end

  def ao3_notes
    if self.is_a? Series
      return work_doc.css(".series dd")[3].children.map(&:text) if doc.css(".series dt")[3].text == "Notes:"
      return work_doc.css(".series dd")[4].children.map(&:text) if doc.css(".series dt")[4].text == "Notes:"
    else
      Scrub.sanitize_html(work_doc.css(".notes blockquote")).children.to_html
    end
  end

  def all_notes
    if self.is_a? Chapter
      if position == 1
        # currently first Chapters don't get anything because the Book got it all
        # TODO separate work summary & notes from chapter summary & notes
        ""
      else
        ao3_notes
      end
    elsif self.is_a? Series
      [add_authors(ao3_authors), add_fandoms(ao3_fandoms), ao3_summary, ao3_notes].join_hr
    else
      [add_authors(ao3_authors), add_fandoms(ao3_fandoms), ao3_relationships.to_p, ao3_summary, ao3_tags.to_p, ao3_notes].join_hr
    end
  end

  def ao3_tt(strings)
    found = []
    strings.each do |string|
      if string.match("Time Travel")
        set_tt
        return self
      end
    end
    return self
  end

  def set_meta
    return false if doc.blank?
    self.update! title: ao3_title, notes: all_notes
    Rails.logger.debug "DEBUG: set title to #{ao3_title} and notes to #{all_notes}"
    set_wip if wip? unless ao3_chapter?
    ao3_tt(ao3_tags) unless ao3_chapter?
  end

  def refetch_recursive
    self.parts.each {|part| part.refetch_recursive}
    self.fetch_raw && set_meta
  end

  def add_authors(strings)
    Rails.logger.debug "DEBUG: add #{strings} to authors"
    return if strings.blank? || parent
    existing = []
    non_existing = []
    strings.each do |single|
      found = nil
      possibles = single.gsub("(", ",").gsub(")", "").split(",")
      possibles.each do |try|
        Rails.logger.debug "DEBUG: trying '#{try}'"
        found = Author.find_by_short_name(try.strip)
        if found
          Rails.logger.debug "DEBUG: found #{try}"
          existing << found
          break
        end
      end
      non_existing << single unless found
    end
    unless existing.empty?
      Rails.logger.debug "DEBUG: adding #{existing.map(&:name)} to authors"
      existing.uniq.each {|a| self.tags << a unless self.tags.authors.include?(a)}
    end
    if non_existing.empty?
      ""
    else
      authors = non_existing.uniq
      by = existing.empty? ? "by" : "et al:"
      Rails.logger.debug "DEBUG: adding #{authors} to notes"
      "<p>#{by} #{authors.join_comma}</p>"
    end
  end

  def add_fandoms(strings)
    Rails.logger.debug "DEBUG: add #{strings} to fandoms"
    return if strings.blank? || parent
    existing = []
    non_existing = []
    strings.each do |t|
      try = t.split(" | ").last.split(" - ").first.split(":").first.split('(').first
      simple = try ? try.strip : t.split(" | ").last
      simple.sub!(/^The /, '')
      simple = I18n.transliterate(simple).delete('?')
      Rails.logger.debug "DEBUG: trying #{simple}"
      found = Fandom.where('name like ?', "%#{simple}%").first
      if found.blank? && simple.present?
        trying = simple.split(/[ -]/)
        Rails.logger.debug "DEBUG: trying #{trying}"
        possibles = trying.collect{|w| Fandom.where('name like ?', "%#{w}%") if w.length > 3}.flatten.compact
        Rails.logger.debug "DEBUG: possible tags are #{possibles.map(&:name)}"
        maybes = possibles.collect{|t| t unless trying.select{|w| t.name.match /\b#{w}\b/ }.empty?}
        Rails.logger.debug "DEBUG: maybe tags are #{maybes.compact.map(&:name)}"
        found = maybes.compact.mode
      end
      if found.blank?
        non_existing << simple if simple.present?
      else
        Rails.logger.debug "DEBUG: found #{found.name}"
        if self.tags.include?(found)
          Rails.logger.debug "DEBUG: won't re-add #{found.name} to tags"
        elsif self.of_present? # use other fandom tag to prevent false positives
           Rails.logger.debug "DEBUG: will NOT add #{found.name} to tags: add to notes instead"
           non_existing << simple if simple.present?
        else
          Rails.logger.debug "DEBUG: will add #{found.name} to tags"
          existing << found
        end
      end
    end
    if existing.empty?
      if self.tags.fandoms.blank?
        Rails.logger.debug "DEBUG: adding #{OTHER} to fandoms"
        self.tags << of_tag
      end
    else
      Rails.logger.debug "DEBUG: adding #{existing.uniq.map(&:name)} to fandoms"
      existing.uniq.each {|f| self.tags << f}
    end
    if non_existing.empty?
      ""
    else
      fandoms = non_existing.uniq
      Rails.logger.debug "DEBUG: adding #{fandoms.join_comma} to notes"
      "<p>#{fandoms.join_comma}</p>"
    end
  end

  # only used in fandom.destroy_me and page.create_from_hash (testing)
  def add_fandoms_to_notes(fandoms)
    self.update! notes: "#{add_fandoms(fandoms)}#{self.notes}"
    return self
  end

  # only used in author.destroy_me
  def add_authors_to_notes(authors)
    self.update! notes: "#{add_authors(authors)}#{self.notes}"
    return self
  end

end
