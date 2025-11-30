# frozen_string_literal: true

module PageNavigate
  def navigate_html_file_name
    FileUtils.mkdir_p(mydirectory) # make sure directory exists
    "#{mydirectory}navigate.html"
  end

  def navigate_html
    Rails.logger.debug { 'getting navigate html from file' }
    File.open(navigate_html_file_name, 'r:utf-8', &:read)
  rescue Errno::ENOENT
    Rails.logger.debug { 'oops. no nav file exists' }
    begin
      File.open(raw_html_file_name, 'r:utf-8', &:read)
    rescue Errno::ENOENT
      Rails.logger.debug { 'oops. no raw file exists either' }
      ''
    end
  end

  def navigate_html=(content)
    Rails.logger.debug { 'saving navigate html' }
    File.open(navigate_html_file_name, 'w:utf-8') { |f| f.write(content) }
  end

  def fetch_navigate
    navigate_url = case type
                   when 'Book'
                     "#{url}/navigate"
                   when 'Series'
                     url
                   else
                     raise 'cannot find navigate url'
                   end
    Rails.logger.debug { "fetching navigate for #{id}: #{navigate_url}" }
    result = navigate_fetch(navigate_url)
    return if errors.present?

    self.navigate_html = result
  end

  def navigate_fetch(url)
    Fetch.fetch_html(url)
  rescue SocketError
    Rails.logger.debug 'host unavailable for nav'
    errors.add(:base, "couldn't resolve host name")
  rescue StandardError
    Rails.logger.debug 'content unavailable'
    errors.add(:base, 'error retrieving content')
  end
end
