# frozen_string_literal: true

# FIXME: tests using this should be in rspec
Then('the notes should be empty') do
  assert Page.first.notes.blank?
end
Then('the notes should NOT include {string}') do |string|
  assert_no_match Regexp.new(string), Page.first.notes
end

Then('the notes should include {string}') do |string|
  assert_match Regexp.new(string), Page.first.notes
end
