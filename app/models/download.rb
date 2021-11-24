module Download

  def self.remove_all_downloads
    Page.all.each do |page|
      page.remove_outdated_downloads
    end;1
  end

  DOWNLOADS = "downloads/"
  def download_dir; mydirectory + DOWNLOADS; end
  def download_url(format)
    "#{mypath}#{DOWNLOADS}/#{download_title}#{format}".gsub(' ', '%20')
  end

  def download_title_diffs
    mine = short_diff_strings
    if self.parent
      mine = mine - parent.short_diff_strings
    end
    mine
  end

  def download_suffix; download_title_diffs.empty? ? "" : " (#{download_title_diffs.join(', ')})"; end
  def download_part_title; title_prefix + title + download_suffix; end

  def remove_outdated_downloads(recurse = false)
    FileUtils.rm_rf(self.download_dir) if self.id
    FileUtils.mkdir_p(self.download_dir) if self.id
    self.parent.remove_outdated_downloads(true) if self.parent
    self.parts.each { |part| part.remove_outdated_downloads(true) unless recurse}
  end

  # needs to be filesystem safe and not overly long
  def download_title
    string = self.title.encode('ASCII', :invalid => :replace, :undef => :replace, :replace => '')
    string = string.gsub(/[^[\w _-]]+/, '')
    string.gsub(/ +/, " ").strip.gsub(/^(.{30}[\w.]*).*/) {$1}
  end
  def download_basename
    "#{self.download_dir}#{self.download_title}"
  end
  ## --authors
  ## if it's hidden, then hide the authors also
  ## if it's not, use the short names
  ## if it's a part, add the parent's authors
  def all_authors;
    my_authors = self.authors
    my_parents_authors = self.parent_id.blank? ? [] : self.parent.all_authors
    (my_authors + my_parents_authors).pulverize.sort_by{|a| a.name}
  end
  def all_authors_string; all_authors.map(&:true_name).join(" & "); end
  def hidden?; cached_hidden_string.present?; end
  def download_author_string; hidden? ? "" : all_authors_string; end
  ## --tags
  ## if it's hidden, then the hidden tags are the only tags
  ## if it's not hidden, then add size and unread (if not read) to not-series tags
  ## if it's a part, add the parent's tags
  def download_tags;
    [(unread? ? Page::UNREAD : ""),
     *tags.not_fandom.not_relationship.not_info.map(&:name),
     ]
  end
  def all_tags;
    my_tags = download_tags
    my_parents_tags = self.parent_id.blank? ? [] : self.parent.all_tags
    (my_tags + my_parents_tags).pulverize
  end
  def download_tag_string; hidden? ? cached_hidden_string : "#{size}, #{all_tags.join_comma}"; end
  ## --series
  ## if it has exactly one relationship, then use that
  ## else if it has more than one fandom, then use "crossover"
  ## else use the fandom
  def all_fandoms;
    my_fandoms = tags.fandom
    my_parents_fandoms = self.parent_id.blank? ? [] : self.parent.all_fandoms
    (my_fandoms + my_parents_fandoms).pulverize
  end
  def all_relationships;
    my_relationships = tags.relationship
    my_parents_relationships = self.parent_id.blank? ? [] : self.parent.all_relationships
    (my_relationships + my_parents_relationships).pulverize
  end
  def fandom_name; all_fandoms.present? ? all_fandoms.first.name : ""; end
  def relationship_name; all_relationships.present? ? all_relationships.first.name : ""; end
  def crossover?; all_fandoms.size > 1; end
  def download_fandom_string
    if all_relationships.size == 1
      relationship_name
    else
      crossover? ? "crossover" : fandom_name;
    end
  end
  ## --comments
  ## if it's hidden, then put the authors (if they exist) into the comments with the hidden tags
  def hidden_comment_string
    return "" unless hidden?
    return hidden_string unless all_authors_string.present?
    "by #{all_authors_string}, #{hidden_string}"
  end
  def all_tags_for_comments
    my_tags = self.tags.fandom.by_name + self.tags.relationship.by_name + self.tags.trope.by_name
    my_parents_tags = self.parent_id.blank? ? [] : self.parent.all_tags_for_comments
    (my_tags + my_parents_tags).pulverize
  end
  def all_tags_for_comments_string
    fandoms = all_tags_for_comments.select{|t| t.type == "Fandom"}
    relationships = all_tags_for_comments.select{|t| t.type == "Relationship"}
    tropes = all_tags_for_comments.select{|t| t.type == ""}
    (fandoms + relationships + tropes).map(&:name).join_comma
  end
  def download_comment_string
    [
      hidden_comment_string,
      all_tags_for_comments_string,
      size_string,
      my_short_notes,
      short_notes,
    ].join_comma
  end

  def epub_tags
    string = %Q{--title "#{self.title}"}
    unless self.download_author_string.blank?
      string = string + %Q{ --authors "#{self.download_author_string}"}
    end
    if self.stars?
      string = string + %Q{ --rating "#{self.stars*2}" }
    end
    unless self.download_tag_string.blank?
      string = string + %Q{ --tags "#{self.download_tag_string}"}
    end
    if self.download_fandom_string.present? && self.cached_hidden_string.blank?
      string = string + %Q{ --series "#{self.download_fandom_string}"}
    end
    unless self.download_comment_string.blank?
      string = string + %Q{ --comments "#{self.download_comment_string}"}
    end
    string
  end
  def epub_command
     cmd = %Q{cd "#{self.download_dir}"; ebook-convert "#{self.download_basename}.html" "#{self.download_basename}.epub" --no-default-epub-cover } + epub_tags
    Rails.logger.debug "DEBUG: #{cmd}"
    # Rails.logger.debug "DEBUG: #{epub_tags}"
    return cmd
  end

  def create_epub
    return if File.exists?("#{self.download_basename}.epub")
    FileUtils.mkdir_p(download_dir) # make sure directory exists
    `#{epub_command} 2> /dev/null`
  end

end
