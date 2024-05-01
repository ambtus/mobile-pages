module Download

  def self.remove_all_downloads
    Page.all.each do |page|
      page.remove_outdated_downloads
    end;1
  end

  def download_dir; "/tmp/downloads/"; end
  def download_url(format); "/downloads/#{id}#{format}"; end
  def download_basename
    "#{self.download_dir}#{self.id}"
  end

  def download_unread_string
    return "" unless self.unread?
    if parent && parent.read_parts.any?
      Page::UNREAD
    else
      ""
    end
  end

  def short_meta_strings; [download_unread_string, *tags.not_info.by_type.by_name.map(&:name)].reject(&:blank?); end

  def title_prefix; parent ? title.match(position.to_s) ? "" : "#{position}. " : ""; end
  def parent_title_prefix; (parent && parent.parent) ? "#{parent.position}." : ""; end
  def gparent_title_prefix; (parent && parent.parent && parent.parent.parent) ? "#{parent.parent.position}." : ""; end
  def download_prefixes; gparent_title_prefix + parent_title_prefix + title_prefix; end

  def title_w_position; (download_prefixes + " " + title).squish; end
  def epub_title
    (parent ? title_w_position + " of #{ultimate_parent.title}" : title_w_position).gsub('"', '')
  end

  def download_suffix; short_meta_strings.empty? ? "" : " (#{short_meta_strings.join_comma})"; end
  def download_part_title; title_w_position + download_suffix; end


  def remove_outdated_downloads
    if self.id
      files = Dir.glob("#{download_dir}#{id}.*")
      Rails.logger.debug "Removing outdated downloads: #{files}"
      FileUtils.rm files
    end
    self.parent.remove_outdated_downloads if self.parent
    return self
  end

  ## --authors
  ## use the short names of the authors and the fandoms
  def author_bns; self.author_tags.map(&:base_name); end
  def fandom_bns; self.fandom_tags.map(&:base_name); end
  def download_author_string; (author_bns + fandom_bns).compact.join("&") || ""; end

  ## --tags
  ## if it's hidden, then the hidden tags are the only tags
  ## if it's not hidden, then add size and unread (if not read) to not-series tags
  ## if it's a part, add the parent's tags
  def download_tag_bns;
    [(unread? ? Page::UNREAD : ""),
     *tags.not_fandom.not_info.not_author.map(&:base_name), *author_bns, *fandom_bns
     ]
  end
  def all_bns;
    mine = download_tag_bns
    my_parents = self.parent_id.blank? ? [] : self.parent.all_bns
    (mine + my_parents).pulverize
  end
  def download_tag_string; hidden? ? tags.hiddens.joined : "#{size}, #{all_bns.join_comma}"; end

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
      short_my_notes,
      short_notes,
      short_end_notes
    ].join_comma
  end

  def epub_tags
    string = %Q{--title "#{self.epub_title}"}
    unless self.download_author_string.blank?
      string = string + %Q{ --authors "#{self.download_author_string}"}
    end
    if self.stars?
      string = hidden? ? string : string + %Q{ --rating "#{self.stars*2}" }
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
    Rails.logger.debug cmd
    # Rails.logger.debug epub_tags
    return cmd
  end

  def create_epub
    return if File.exists?("#{self.download_basename}.epub")
    FileUtils.mkdir_p(download_dir) # make sure directory exists
    `#{epub_command} 2> /dev/null`
  end

end
