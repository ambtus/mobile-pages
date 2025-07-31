# frozen_string_literal: true

module Download
  def self.remove_all_downloads
    Page.find_each(&:remove_outdated_downloads)
    1
  end

  def download_dir = '/tmp/downloads/'
  def download_url(format) = "/downloads/#{id}#{format}"

  def download_basename
    "#{download_dir}#{id}"
  end

  def wip_string
    (wip? ? 'WIP' : '')
  end

  def favorite_string
    (favorite? ? 'Favorite' : '')
  end

  def download_unread_string
    return '' unless unread?

    if parent&.read_parts&.any?
      Page::UNREAD
    else
      ''
    end
  end

  def short_meta_strings = [download_unread_string, *tags.title_suffixes.by_type.map(&:base_name)].compact_blank
  def download_suffix = short_meta_strings.empty? ? '' : " (#{short_meta_strings.join_comma})"

  def title_prefix
    if parent
      title.match(position.to_s) ? '' : "#{position}. "
    else
      ''
    end
  end

  def parent_title_prefix = parent&.parent ? "#{parent.position}." : ''
  def gparent_title_prefix = parent&.parent&.parent ? "#{parent.parent.position}." : ''
  def download_prefixes = gparent_title_prefix + parent_title_prefix + title_prefix

  def title_w_position = "#{download_prefixes} #{title}".squish

  def epub_title
    (parent ? title_w_position + " of #{ultimate_parent.title}" : title_w_position).delete('"')
  end

  def download_part_title = title_w_position + download_suffix

  def header_id = title.clean

  def remove_outdated_downloads
    if id
      files = Dir.glob("#{download_dir}#{id}.*")
      Rails.logger.debug { "Removing outdated downloads: #{files}" }
      FileUtils.rm files
    end
    parent&.remove_outdated_downloads
    self
  end

  ## --authors
  ## use the short names of the authors and the fandoms
  def author_bns = author_tags.map(&:base_name)
  def fandom_bns = fandom_tags.map(&:base_name)
  def download_author_string = (author_bns + fandom_bns).compact.join('&') || ''

  ## --tags
  ## if it's hidden, then the hidden tags are the only tags
  ## if it's not hidden, then add size and unread (if not read) to not-series tags
  ## if it's a part, add the parent's tags
  def download_tag_bns
    [(unread? ? Page::UNREAD : ''),
     wip_string,
     favorite_string,
     *tags.not_fandom.not_info.not_author.map(&:base_name), *author_bns, *fandom_bns]
  end

  def all_bns
    mine = download_tag_bns
    my_parents = parent.blank? ? [] : parent.all_bns
    (mine + my_parents).pulverize
  end

  def download_tag_string = hidden? ? tags.hiddens.joined : "#{size}, #{all_bns.join_comma}"

  ## --comments
  def pros_and_cons
    mine = tags.pros.by_name + tags.cons.by_name
    my_parents = parent.blank? ? [] : parent.pros_and_cons
    (mine + my_parents).pulverize
  end

  def pros_and_cons_string
    pros = pros_and_cons.select { |t| t.type == 'Pro' }
    cons = pros_and_cons.select { |t| t.type == 'Con' }
    (pros + cons).map(&:name).join_comma
  end

  def download_comment_string
    [
      wip_string,
      favorite_string,
      pros_and_cons_string,
      size_string,
      short_my_notes,
      short_notes,
      short_end_notes
    ].join_comma
  end

  def epub_tags
    string = %(--title "#{epub_title}")
    string += %( --authors "#{download_author_string}") if download_author_string.present?
    string += %( --rating "#{stars * 2}" ) if read? && (stars? || old_stars?) && !hidden?
    string += %( --tags "#{download_tag_string}") if download_tag_string.present?
    string += %( --comments "#{download_comment_string}") if download_comment_string.present?
    string
  end

  def epub_command
    cmd = %(cd "#{download_dir}"; ebook-convert "#{download_basename}.html" "#{download_basename}.epub" --no-default-epub-cover ) + epub_tags
    Rails.logger.debug cmd
    # Rails.logger.debug epub_tags
    cmd
  end

  def create_epub
    return if File.exist?("#{download_basename}.epub")

    FileUtils.mkdir_p(download_dir) # make sure directory exists
    `#{epub_command} 2> /dev/null`
  end
end
