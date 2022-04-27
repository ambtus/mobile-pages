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
      Nokogiri::HTML(raw_html)
    end
  end

  def wip?
    return false if self.is_a? Series # ignore wip status of series
    chapters = doc.css(".stats .chapters").children[1].text.split('/') rescue Array.new
    Rails.logger.debug "DEBUG: wip status: #{chapters}"
    chapters.second == "?" || chapters.first != chapters.second
  end

  def my_fandoms
    if self.parts.empty?
      Rails.logger.debug "DEBUG: get fandoms from raw_html"
      doc.css(".fandom a").map(&:children).map(&:text)
    else
      Rails.logger.debug "DEBUG: get fandoms from first and last parts"
      (parts.first.my_fandoms + parts.last.my_fandoms).uniq
    end
  end

  def my_tags
    if self.parts.empty?
      Rails.logger.debug "DEBUG: get tags from raw_html"
      doc.css(".freeform a").map(&:children).map(&:text)
    else
      Rails.logger.debug "DEBUG: get tags from first and last parts"
      (parts.first.my_tags + parts.last.my_tags).uniq
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

  def set_tags
    set_wip if wip?
    ao3_tt(my_tags)
  end

  def add_author(string)
    return if string.blank?
    return if parent
    existing = []
    non_existing = []
    singles = string.split(", ")
    singles.each do |single|
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
    unless non_existing.empty?
      authors = non_existing.uniq
      by = existing.empty? ? "by" : "et al:"
      unless authors.empty?
        Rails.logger.debug "DEBUG: adding #{authors} to notes"
        self.update notes: "<p>#{by} #{authors.join_comma}</p>#{self.notes}"
      end
    end
    return self
  end

  def add_fandom(string)
    return if string.blank?
    return if parent
    tries = string.split(", ")
    existing = []
    non_existing = []
    tries.each do |t|
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
    unless non_existing.empty?
      fandoms = non_existing.uniq
      unless fandoms.empty?
        Rails.logger.debug "DEBUG: adding #{fandoms} to notes"
        self.update notes: "<p>#{fandoms.join_comma}</p>#{self.notes}"
      end
    end
    return self
  end

end
