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

  def download_unread_string
    return "" unless self.unread?
    if parent && parent.read_parts.any?
      self.unfinished? ? Page::UNFINISHED : Page::UNREAD
    else
      ""
    end
  end

  def short_meta_strings; [download_unread_string, *tags.not_info.by_type.by_name.map(&:name)].reject(&:blank?); end

  def download_suffix; short_meta_strings.empty? ? "" : " (#{short_meta_strings.join_comma})"; end
  def download_part_title; title_prefix + title + download_suffix; end

  def remove_outdated_downloads
    FileUtils.rm_rf(self.download_dir) if self.id
    FileUtils.mkdir_p(self.download_dir) if self.id
    self.parent.remove_outdated_downloads if self.parent
    return self
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
  ## use the short names of the authors
  ## if it's a part, add the parent's authors and fandoms
  def all_authors;
    my_authors = self.tags.authors
    my_parents_authors = self.parent_id.blank? ? [] : self.parent.all_authors
    (my_authors + my_parents_authors).pulverize
  end
  def all_fandoms;
    mine = self.tags.fandoms
    my_parents = self.parent_id.blank? ? [] : self.parent.all_fandoms
    (mine + my_parents).pulverize
  end
  def download_author_string; (all_authors.map(&:base_name) + all_fandoms.map(&:base_name)).compact.join("&") || ""; end

  ## --tags
  ## if it's hidden, then the hidden tags are the only tags
  ## if it's not hidden, then add size and unread (if not read) to not-series tags
  ## if it's a part, add the parent's tags
  def download_tags;
    [(unread? ? Page::UNREAD : ""),
     *tags.not_fandom.not_info.not_author.map(&:name),
     ]
  end
  def all_tags;
    mine = download_tags
    my_parents = self.parent_id.blank? ? [] : self.parent.all_tags
    (mine + my_parents).pulverize
  end
  def download_tag_string; hidden? ? tags.hiddens.joined : "#{size}, #{all_tags.join_comma}"; end

  ## --comments
  def pros_and_cons
    mine = self.tags.pros.by_name + self.tags.cons.by_name
    my_parents = self.parent_id.blank? ? [] : self.parent.pros_and_cons
    (mine + my_parents).pulverize
  end
  def pros_and_cons_string
    pros = pros_and_cons.select{|t| t.type == "Pro"}
    cons = pros_and_cons.select{|t| t.type == "Con"}
    (pros + cons).map(&:name).join_comma
  end
  def download_comment_string
    [
      pros_and_cons_string,
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
