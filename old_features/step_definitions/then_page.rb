# frozen_string_literal: true

## thens which call the Page model ##

Then('the end notes should be empty') do
  assert Page.first.end_notes.blank?
end

Then('the end notes should start with {string}') do |string|
  assert_match Regexp.new("^#{string}"), Page.first.end_notes
end

Then('the end notes should end with {string}') do |string|
  assert_match Regexp.new("#{string}$"), Page.first.end_notes
end

Then('all wordcounts should be {int}') do |int|
  assert_equal [int], Page.all.map(&:wordcount).uniq
end

Then('I should have {int} works') do |int|
  assert_equal int, Page.count
end

Then('I should have {int} nodes') do |int|
  Rails.logger.debug { "comparing #{Page.first.nodes.count} with #{int}" }
  assert_equal int, Page.first.nodes.count
end
