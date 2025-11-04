# frozen_string_literal: true

Given('link in notes exists') do
  page = Single.new title: 'Silent Sobs', notes: (note_file 'silent')
  page.save!
end

Given('a page with very long notes exists') do
  page = Single.new title: 'VLN', notes: very_long_note
  page.save!
end
