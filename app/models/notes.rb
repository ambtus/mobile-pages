# frozen_string_literal: true

module Notes

  SHORT_LENGTH = 160 # truncate at this many characters
  MEDIUM_LENGTH = 480

  def formatted_my_notes = Scrub.sanitize_html(my_notes)
  def formatted_notes = Scrub.sanitize_html(notes)
  def formatted_end_notes = Scrub.sanitize_html(end_notes)

  def truncate(string, length = SHORT_LENGTH)
    return '' if string.blank?

    Scrub.sanitize_html(string.truncate(length, separator: /\s+/, omission: '…'))
  end

  # used in show view, scrubbbed but not stripped, and longer
  def medium_notes = truncate(notes, MEDIUM_LENGTH)

  def scrub_and_truncate(string)
    stripped_truncated_and_scrubbed = truncate Scrub.sanitize_and_strip(string)
    # RubyPants turns quotes into smart quotes
    # so they don't mess up the epub command
    RubyPants.new(stripped_truncated_and_scrubbed).to_html.html_safe
  end

  # used in index view and in epub comments
  def short_notes = scrub_and_truncate(notes)
  def short_my_notes = scrub_and_truncate(my_notes)
  def short_end_notes = scrub_and_truncate(end_notes)

end
