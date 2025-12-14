# frozen_string_literal: true

module PageDownload
  DOWNLOAD_DIR = '/tmp/downloads/'
  FileUtils.mkdir_p(DOWNLOAD_DIR)

  def download_url(format) = "/downloads/#{id}#{format}"
  def temporary_file(format) = "#{DOWNLOAD_DIR}#{id}#{format}"

  def render_html = Render.render_html(self)
  def rendered_html = File.read(temporary_file('.html'))

  def render_read_aloud = Render.render_read_aloud(self)
  def rendered_read_aloud = File.read(temporary_file('.read'))

  def render_epub = Render.render_epub(self)
  def epub_file = temporary_file('.epub')

  def remove_outdated_downloads
    if id
      files = Dir.glob("#{DOWNLOAD_DIR}#{id}.*")
      Rails.logger.debug { "Removing outdated downloads: #{files}" }
      FileUtils.rm files
    end
    parent&.remove_outdated_downloads
    self
  end

  ### create the epub tags

  def epub_title
    (parent ? title_w_position + " of #{ultimate_parent.title}" : title_w_position).delete('"')
  end

  def download_author_string = (author_bns + fandom_bns).compact.join('&') || ''
  def download_tag_string = hidden? ? tags.hiddens.joined : "#{size}, #{all_bns.join_comma}"

  def download_comment_string
    [
      wip_string,
      favorite_string,
      pros_and_cons_string,
      size_string,
      safe_my_notes,
      safe_notes,
      safe_end_notes
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

  ## create the epub command

  def epub_command
    cmd = %(cd "#{DOWNLOAD_DIR}"; ebook-convert "#{temporary_file('.html')}" "#{temporary_file('.epub')}" --no-default-epub-cover ) + epub_tags
    Rails.logger.debug cmd
    # Rails.logger.debug epub_tags
    cmd
  end

  def wip_string = (wip? ? 'WIP' : '')
  def favorite_string = (favorite? ? 'Favorite' : '')

  def download_unread_string
    return '' unless unread?

    parent&.read_parts&.any? ? 'unread' : ''
  end

  def short_meta_strings = [download_unread_string, *tags.title_suffixes.by_type.map(&:base_name)].compact_blank

  def download_suffix = short_meta_strings.empty? ? '' : " (#{short_meta_strings.join_comma})"

  def download_prefixes = gparent_title_prefix + parent_title_prefix + title_prefix

  def title_w_position = "#{download_prefixes} #{title}".squish

  def download_part_title = title_w_position + download_suffix

  def header_id = title.clean

  ## --authors
  ## use the short names of the authors and the fandoms
  def author_bns = author_tags.map(&:base_name)
  def fandom_bns = fandom_tags.map(&:base_name)

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
end
