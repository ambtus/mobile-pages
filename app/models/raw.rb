# frozen_string_literal: true

module Raw

  def raw_html
    File.open(raw_html_file_name, 'r:utf-8', &:read)
  rescue Errno::ENOENT
    ''
  end

  def raw_html=(content)
    remove_outdated_downloads
    body = Scrub.regularize_body(content)
    File.open(raw_html_file_name, 'w:utf-8') { |f| f.write(body) }
    build_clean_from_raw
  end

  def fetch_raw
    Rails.logger.debug 'fetching raw html'
    return false if ff? || ao3?

    html = scrub_fetch(url)
    return false unless html

    self.raw_html = html
    remove_outdated_downloads
    self
  end

  def scrub_fetch(url)
    Rails.logger.debug { "fetching raw html from #{url}" }
    Scrub.fetch_html(url)
  rescue SocketError
    Rails.logger.debug 'host unavailable'
    errors.add(:base, "couldn't resolve host name")
    false
  rescue StandardError
    Rails.logger.debug 'content unavailable'
    errors.add(:base, 'error retrieving content')
    false
  end

  def raw_html_file_name
    FileUtils.mkdir_p(mydirectory) # make sure directory exists
    "#{mydirectory}raw.html"
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

end
