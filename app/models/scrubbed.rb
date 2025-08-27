# frozen_string_literal: true

module Scrubbed

  def scrubbed_html_file_name
    "#{mydirectory}scrubbed.html"
  end

  def scrubbed_html=(content)
    remove_outdated_downloads
    remove_outdated_edits
    content = Scrub.remove_surrounding(content) if nodes(content).size == 1
    File.open(scrubbed_html_file_name, 'w:utf-8') { |f| f.write(content) }
  end

  def scrubbed_html
    return if parts.present?

    begin
      File.open(scrubbed_html_file_name, 'r:utf-8', &:read)
    rescue Errno::ENOENT
      ''
    end
  end

  def rebuild_edited_from_clean
    remove_outdated_downloads
    if parts.size.positive?
      parts.each(&:rebuild_edited_from_clean)
    else
      FileUtils.rm_f(edited_html_file_name)
    end
    self
  end

end
