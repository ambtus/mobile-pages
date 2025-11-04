# frozen_string_literal: true

module PageNotes
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

  def scrub_and_truncate(string) = (truncate Scrub.sanitize_and_strip(string)).html_safe

  # used in index view
  def short_notes = scrub_and_truncate(notes)
  def short_my_notes = scrub_and_truncate(my_notes)
  def short_end_notes = scrub_and_truncate(end_notes)

  # used in epub comments
  def safe_notes = Scrub.make_safe(notes)
  def safe_my_notes = Scrub.make_safe(my_notes)
  def safe_end_notes = Scrub.make_safe(end_notes)
end
