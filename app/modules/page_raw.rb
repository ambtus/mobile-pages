# frozen_string_literal: true

module PageRaw
  def raw_html_file_name
    FileUtils.mkdir_p(mydirectory) # make sure directory exists
    "#{mydirectory}raw.html"
  end

  def raw_html
    File.open(raw_html_file_name, 'r:utf-8', &:read)
  rescue Errno::ENOENT
    ''
  end

  def raw_html=(content)
    Rails.logger.debug { 'saving raw html' }
    body = Scrub.regularize_body(content)
    File.open(raw_html_file_name, 'w:utf-8') { |f| f.write(body) }
    build_clean_from_raw
  end

  def fetch_raw
    Rails.logger.debug { "fetching raw html from #{url}" }

    html = raw_fetch(url)
    return self if html.blank? || errors.present?

    self.raw_html = html
    self
  end

  def raw_fetch(url)
    Fetch.fetch_html(url)
  rescue SocketError
    Rails.logger.debug 'host unavailable for raw'
    errors.add(:base, "couldn't resolve host name")
    false
  rescue StandardError
    Rails.logger.debug 'content unavailable'
    errors.add(:base, 'error retrieving content')
    false
  end

  def build_clean_from_raw
    html = Websites.getnode(raw_html, url)
    if html
      Rails.logger.debug 'updating scrubbed html from raw'
      first_pass = Scrub.sanitize_html(html)
      self.scrubbed_html = Scrub.sanitize_html(first_pass)
    else
      Rails.logger.debug 'no scrubbed html available from raw'
      self.scrubbed_html = ''
    end
    set_wordcount
  end

  def rebuild_clean_from_raw
    remove_outdated_downloads
    if parts.size.positive?
      parts.each(&:rebuild_clean_from_raw)
      set_wordcount(false)
    else
      build_clean_from_raw
    end
    self
  end

  def refetch(passed_url)
    if ao3? && type == 'Single' && url.exclude?('chapters')
      if make_me_a_chapter(passed_url)
        move_tags_up
        move_soon_up
        set_meta
        parent.reload
      else
        update!(url: passed_url) if passed_url.present?
        fetch_ao3
        self
      end
    else
      update!(url: passed_url) if passed_url.present?
      Rails.logger.debug { "refetching all for #{id} url: #{url}" }
      if ao3?
        fetch_ao3
        errors.messages.each { |e| errors.add(e.first, e.second.join_comma) }
        self
      else
        fetch_raw
        set_meta && parent&.set_wordcount(false) if errors.blank?
        self
      end
    end
  end
end
