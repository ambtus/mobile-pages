# frozen_string_literal: true

module PageEdited
  def edited_html_file_name
    "#{mydirectory}edited.html"
  end

  def edited_html=(content)
    remove_outdated_downloads
    body = Scrub.sanitize_html(content)
    File.open(edited_html_file_name, 'w:utf-8') { |f| f.write(body) }
    set_wordcount
  end

  ## if it doesn't exist (I haven't edited) use the scrubbed version
  def edited_html
    File.open(edited_html_file_name, 'r:utf-8', &:read)
  rescue Errno::ENOENT
    begin
      File.open(scrubbed_html_file_name, 'r:utf-8', &:read)
    rescue Errno::ENOENT
      ''
    end
  end

  def remove_edited
    remove_outdated_downloads
    if parts.size.positive?
      parts.each(&:remove_edited)
    else
      FileUtils.rm_f(edited_html_file_name)
    end
    self
  end
end
