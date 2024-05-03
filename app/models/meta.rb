module Meta
  include SpecialTags

  def toggle_end; toggle! :at_end; return self; end
  def end_notes_in_notes?; end_notes.present? && !at_end; end
  def show_notes; notes.present? || my_notes.present? || end_notes_in_notes?; end
  def show_end_notes; end_notes.present? && at_end; end

  def hr1?; notes.present? && my_notes.present?; end
  def hr2?
    if hr1?
      end_notes_in_notes?
    else
      (notes.present? || my_notes.present?) && end_notes_in_notes?
    end
  end

  def doc
    if self.type == "Book" && !wp?
      Rails.logger.debug "getting doc from last part"
      Nokogiri::HTML(parts.last.raw_html)
    else
      Rails.logger.debug "getting doc from raw_html"
      fetch_raw if raw_html.blank?
      Nokogiri::HTML(raw_html)
    end
  end

  def book_doc; type == "Book" ? Nokogiri::HTML(parts.first.raw_html) : doc; end

  def wip?
    return false unless %w{Book Single}.include?(type)
    return false if chapter_as_single?
    chapters = doc.css(".stats .chapters").children[1].text.split('/') rescue Array.new
    Rails.logger.debug "wip status: #{chapters}"
    chapters.second == "?" || chapters.first != chapters.second
  end

  def old_ff_style_hash
    return {} unless ff? || first_part_ff?
    book_doc.css('td script').text.create_hash("\n  ", " = ", true, "var ") rescue {}
  end

  def inferred_fandoms
    if can_have_tags?
      Rails.logger.debug "getting fandoms from raw_html"
      if ao3?
        doc.css(".fandom a").map(&:children).map(&:text)
      elsif ff? || first_part_ff?
        hash = old_ff_style_hash[:cat_title]
        links = doc.css("#pre_story_links a")[1].text rescue nil
        [hash, links].pulverize
      elsif wp?
        first_try = wp_try("Fandom")
        if first_try.blank? && parts.any?
          (parts.first.inferred_fandoms + parts.last.inferred_fandoms).uniq
        else
          Scrub.sanitize_and_strip(first_try).split(", ").without("Time Travel").without("Fix-it")
        end
      else
        []
      end
    else
      Rails.logger.debug "fandoms will be inferred from child or parent"
      []
    end
  end

  def inferred_relationships
    if self.parts.empty? || wp?
      Rails.logger.debug "getting relationships from raw_html"
      if wp?
        [wp_try("Relationship"), wp_try("Pairing")].pulverize
      else
        doc.css(".relationship a").map(&:children).map(&:text)
      end
    else
      Rails.logger.debug "get relationships from first and last parts"
      (parts.first.inferred_relationships + parts.last.inferred_relationships).uniq
    end
  end

  def inferred_tags(my_if=[])
    if self.parts.empty? || wp?
      Rails.logger.debug "getting inferred tags from raw_html"
      if wp?
        wp_try("Genre").split(", ") + wp_try("Warnings").split(", ") - my_if
      else
        doc.css(".freeform a").map(&:children).map(&:text)
      end
    else
      Rails.logger.debug "get tags from first and last parts"
      (parts.first.inferred_tags + parts.last.inferred_tags).uniq
    end
  end

  def inferred_authors
    if can_have_tags?
      Rails.logger.debug "getting authors from raw_html"
      if ao3?
        doc.css(".byline a").map(&:text)
      elsif ff? || first_part_ff?
        hash = old_ff_style_hash[:author]
        links = [doc.css("#profile_top a").first.text] rescue nil
        [hash, links].pulverize
      elsif cn?
        ["Claire Watson"]
      elsif km?
        ["Keira Marcos"]
      end
    else
      Rails.logger.debug "authors will be inferred from child or parent"
      []
    end
  end

  def chapter_title
    if ao3?
      new =
      doc.css(".chapter .title").children.last.text.strip.gsub(/^: /,"") rescue nil
      if title.boring?
        new
      elsif parent && parent.title == title
        new
      else
        title
      end
    elsif ff?
      new = doc.search('option[@selected="selected"]').children[0].text.match(/\d+\. (.*)/) rescue nil
      old = doc.search('option[@selected="selected"]').children[1].text.match(/\d+\. (.*)/) rescue nil
      [new, old].pulverize.first
      $1
    elsif cn?
      doc.at("h1").text.gsub("–", "—").split("—").second.squish
    elsif km?
      doc.at("h1").text.split("–", 2).second.squish
    end
  end

  def work_title
    if ao3?
      begin
        book_doc.xpath("//div[@id='main']").xpath("//h2").first.children.text.strip
      rescue
        if title.blank? || title == "temp"
          "title not found"
        else
          title
        end
      end
    elsif ff? || first_part_ff?
      new = book_doc.css("#profile_top b").text rescue nil
      old = old_ff_style_hash[:title_t]
      [new, old].pulverize.first || "title not found"
    elsif wp?
      doc.at("h1").text.gsub("–", "—").split("—").first.squish
    elsif wikipedia?
      doc.at('h1.firstHeading').text.strip
    else
      "title not found"
    end
  end

  def inferred_title
    if type == "Chapter"
      if chapter_title.blank? || chapter_title.boring?
        if title.blank? || title.boring?
          Rails.logger.debug "replacing title: #{title} with chapter and position"
          "Chapter #{position}"
        else
          Rails.logger.debug "keeping original title: #{title}"
          title
        end
      else
        chapter_title
      end
    elsif type == "Single"
      if chapter_as_single?
        # A Single with a chapter url gets a chapter title, unless it is empty or Chapter X
        Rails.logger.debug "chapter title: #{chapter_title}, work title: #{work_title}"
        if chapter_title.blank? || chapter_title.boring?
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

  def work_summary
    if wp?
      wp_try("Summary")
    elsif type == "Series" && ao3?
      begin
        return doc.css(".series dd")[3].css("blockquote").children.to_html if doc.css(".series dt")[3].text == "Description:"
        return doc.css(".series dd")[4].css("blockquote").children.to_html if doc.css(".series dt")[4].text == "Description:"
      rescue
        ""
      end
    elsif %w{Book Single}.include?(type)
      if ao3?
        Scrub.sanitize_html(book_doc.css(".summary blockquote").to_html)
      elsif ff? || first_part_ff?
        new = book_doc.css(".xcontrast_txt[style='margin-top:2px']").children.to_html
        old = old_ff_style_hash[:summary]
        [new, old].pulverize.first
      end
    end
  end

  def work_notes
    if wp? && type=="Series"
      content = doc.at(".entry-content")
      content.children.each do |node|
        node.remove if node.name == "div"
      end
      Scrub.sanitize_html(content.children.to_html)
    elsif wp?
      [doc.css('div.tab-pane')[2]&.to_html, doc.css('div.tab-pane')[1]&.to_html, wp_try("Authors? [Nn]otes?")].join_hr
    elsif type == "Series" && ao3?
      begin
        return doc.css(".series dd")[3].css("blockquote").children.to_html if doc.css(".series dt")[3].text == "Notes:"
        return doc.css(".series dd")[4].css("blockquote").children.to_html if doc.css(".series dt")[4].text == "Notes:"
      rescue
        ""
      end
    elsif %w{Book Single}.include?(type)
      Scrub.sanitize_html(book_doc.css("[class='notes module'] blockquote").to_html)
    end
  end

  def chapter_summary
    if %w{Chapter Single}.include?(type)
      Scrub.sanitize_html(doc.css("div#summary blockquote").to_html)
    end
  end

  def chapter_notes
    if %w{Chapter Single}.include?(type)
      Scrub.sanitize_html(doc.css("div#notes blockquote").to_html)
    end
  end

  def chapter_end_notes
    if %w{Chapter Single}.include?(type)
      Scrub.sanitize_html(doc.css("div[id^=chapter_] blockquote").to_html)
    end
  end

  def work_end_notes
    if %w{Book Single}.include?(type)
      Scrub.sanitize_html(doc.css("div#work_endnotes blockquote").to_html)
    end
  end

  def tail_notes
    case type
    when "Chapter"
      chapter_end_notes
    when "Single"
      if chapter_as_single?
        chapter_end_notes
      else
        [chapter_end_notes, work_end_notes].join_hr
      end
    when "Book"
      work_end_notes
    end
  end

  def note_tags; inferred_tags.without(TT).without(FI).join(", "); end

  def head_notes(my_if, my_ia, my_ir)
    case type
    when "Chapter"
      if wp?
        [add_fandoms(my_if), my_ir.join(", "), work_summary, note_tags, work_notes]
      else
        [chapter_summary, chapter_notes]
      end
    when "Single"
      if chapter_as_single?
        [add_authors(my_ia), add_fandoms(my_if), chapter_summary, chapter_notes]
      else
        [add_authors(my_ia), add_fandoms(my_if), my_ir.join(", "), work_summary, chapter_summary, note_tags, work_notes, chapter_notes]
      end
    when "Book"
      [add_authors(my_ia), add_fandoms(my_if), my_ir.join(", "), work_summary, note_tags, work_notes]
    when "Series"
      [add_authors(my_ia), add_fandoms(my_if), work_summary, work_notes]
    else # oops?
      ["why am i a #{type}?"]
    end.join_hr
  end

  def inferred_notes(my_if, my_ia, my_ir)
    if scrubbed_notes?
      Rails.logger.debug "not replacing scrubbed notes"
      return notes
    end
    new_head_notes = head_notes(my_if, my_ia, my_ir)
    if new_head_notes.present?
      new_head_notes
    elsif notes.present? && ff?
      Rails.logger.debug "not deleting old ff notes"
      notes
    else
      ""
    end
  end

  def set_meta
    unless ao3? || ff? || first_part_ff? || wp? || wikipedia?
      Rails.logger.debug "only ao3 & fanfiction.net && wordpress for now"
      return false
    end
    if raw_html.blank? && parts.blank?
      Rails.logger.debug "can't set meta without information"
      return false
    end
    Rails.logger.debug "setting meta for #{title} (#{self.class}) with scrubbed_notes: #{scrubbed_notes?}"
    Rails.logger.debug "looking for possible new title"
    my_it = self.inferred_title
    Rails.logger.debug "title is #{my_it}"
    self.update!(title: my_it) unless title == my_it
    Rails.logger.debug "looking for possible new fandoms"
    my_if = self.inferred_fandoms
    Rails.logger.debug "inferred fandoms are #{my_if}"
    Rails.logger.debug "looking for possible new authors"
    my_ia = self.inferred_authors
    Rails.logger.debug "inferred authors are #{my_ia}"
    Rails.logger.debug "looking for possible new relationships"
    my_ir = self.inferred_relationships
    Rails.logger.debug "inferred relationships are #{my_ir}"
    Rails.logger.debug "looking for possible new notes"
    my_in = self.inferred_notes(my_if, my_ia, my_ir)
    Rails.logger.debug "notes are #{my_in}"
    self.update!(notes: my_in) unless notes == my_in
    Rails.logger.debug "looking for possible new end notes"
    my_en = self.tail_notes
    Rails.logger.debug "end notes are #{my_en}"
    self.update!(end_notes: my_en) unless end_notes == my_en
    Rails.logger.debug "looking for possible new wip"
    my_wip = self.wip?
    Rails.logger.debug "wip is #{my_wip}"
    my_wip ? set_wip : unset_wip
    Rails.logger.debug "looking for possible new inferred_tags"
    my_it = self.inferred_tags(my_if)
    Rails.logger.debug "inferred_tags are #{my_it}"
    unless chapter_url?
      my_it.each do |string|
        set_tt if string.match("Time Travel")
        set_fi if string.match(/Fix[- ][iI]t/)
      end
    end
    self.update_tag_cache!
    return self
  end

  def refetch_recursive
    self.parts.each {|part| part.refetch_recursive}
    self.fetch_raw && set_meta
  end

  def add_authors(strings)
    Rails.logger.debug "attempting to add #{strings} to authors"
    return if strings.blank? || !can_have_tags?
    existing = []
    non_existing = []
    strings.each do |single|
      found = nil
      possibles = single.gsub("(", ",").gsub(")", "").split(",")
      possibles.each do |try|
        Rails.logger.debug "trying '#{try}'"
        found = Author.find_by_short_name(try.strip)
        if found
          Rails.logger.debug "found #{try}"
          existing << found
          break
        end
      end
      non_existing << single unless found
    end
    unless existing.empty?
      Rails.logger.debug "adding #{existing.map(&:name)} to authors"
      existing.uniq.each {|a| self.tags << a unless self.tags.authors.include?(a)}
    end
    if non_existing.empty?
      ""
    else
      authors = non_existing.uniq
      by = existing.empty? ? "by" : "et al:"
      Rails.logger.debug "adding #{by} #{authors} to notes"
      "<p>#{by} #{authors.join_comma}</p>"
    end
  end

  def add_fandoms(strings)
    Rails.logger.debug "attempting to add #{strings} to fandoms"
    return if strings.blank? || !can_have_tags?
    existing = []
    non_existing = []
    strings.each do |t|
      try = t.split(" | ").last.split(" - ").first.split(":").first.split('(').first
      simple = try ? try.strip : t.split(" | ").last
      simple.sub!(/^The /, '')
      simple = I18n.transliterate(simple).delete('?')
      Rails.logger.debug "trying #{simple}"
      found = Fandom.where('name like ?', "%#{simple}%").first
      if found.blank? && simple.present?
        trying = simple.split(/[ -]/)
        Rails.logger.debug "trying #{trying}"
        possibles = trying.collect{|w| Fandom.where('name like ?', "%#{w}%") if w.length > 3}.flatten.compact
        Rails.logger.debug "possible tags are #{possibles.map(&:name)}"
        maybes = possibles.collect{|t| t unless trying.select{|w| t.name.match /\b#{w}\b/ }.empty?}
        Rails.logger.debug "maybe tags are #{maybes.compact.map(&:name)}"
        found = maybes.compact.mode
      end
      if found.blank?
        non_existing << simple if simple.present?
      else
        Rails.logger.debug "found #{found.name}"
        if self.tags.include?(found)
          Rails.logger.debug "won't re-add #{found.name} to tags"
        elsif self.of_present? # use other fandom tag to prevent false positives
           Rails.logger.debug "will NOT add #{found.name} to tags: add to notes instead"
           non_existing << simple if simple.present?
        else
          Rails.logger.debug "will add #{found.name} to tags"
          existing << found
        end
      end
    end
    if existing.empty?
      if self.tags.fandoms.blank?
        Rails.logger.debug "adding #{OTHER} to fandoms"
        self.tags << of_tag
      end
    else
      Rails.logger.debug "adding #{existing.uniq.map(&:name)} to fandoms"
      existing.uniq.each {|f| self.tags << f}
    end
    if non_existing.empty?
      ""
    else
      fandoms = non_existing.uniq
      Rails.logger.debug "adding #{fandoms.join_comma} to notes"
      "<p>#{fandoms.join_comma}</p>"
    end
  end

  # only used in Fandom.destroy_me and Utilities.create_from_hash (testing)
  def add_fandoms_to_notes(fandoms)
    self.update! notes: "#{add_fandoms(fandoms)}#{self.notes}"
    return self
  end

  # only used in author.destroy_me
  def add_authors_to_notes(authors)
    self.update! notes: "#{add_authors(authors)}#{self.notes}"
    return self
  end

  # only used in reader.destroy_me
  def add_reader_to_my_notes(reader)
    self.update! my_notes: "read by #{reader}#{self.my_notes}"
    return self
  end

  def wp_try(string)
    return "" if doc.at("strong").blank?
    all = doc.at("strong").parent.inner_html.squish.gsub("<strong><a ", "<a ").gsub("</a></strong>", "</a>")
    metas = all.split("<strong>").pulverize
    found = find_me(metas, string)
    if found.blank?
      all = doc.at("strong").parent.parent.inner_html.squish
      metas = all.split("<div").collect{|d| d.split("<strong>")}.pulverize
      found = find_me(metas, string)
    end
    if found.blank?
      try = doc.css("strong").children.map(&:text).find{|t| t.match(string)}
      if try == string + ":"
        found = doc.css("strong").children.map(&:children).flatten.map(&:text).find{|t| t.match(string)}
      else
        found = try
      end
    end
    if found
      match = found.split(":", 2).second.squish rescue ""
      if string == "Warnings"
        return "" if match.match("None")
      end
      match.gsub(/n\/a/i, "").gsub(Regexp.new("</em><em>$"), '').gsub(Regexp.new('<br> ?$'), '').squish
    else
      ""
    end
  end

  def find_me(metas, string)
    found = metas.find {|m| m.match(string)} rescue nil
    if found
       clean_found = Scrub.sanitize_and_strip(found)
       if clean_found.scan(/:/).count > 1
         parts = found.split("<br>")
         found = parts.find {|p| p.match(string)}
       end
       found.match(Regexp.new("#{string}(.*)"))[1].gsub("</strong>", '')
    end
  end

end
