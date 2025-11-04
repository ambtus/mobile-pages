# frozen_string_literal: true

Then('show me the page') do
  save_and_open_page
end

Then('I should get a {int}') do |int|
  expect(page.status_code).to be int
end

Then('I should NOT get a {int}') do |_int|
  expect(page.status_code).to be 200
end

Then('I should see {string}') do |text|
  assert_text(text)
end

Then('I should NOT see {string}') do |text|
  assert_no_text(text)
end

Then('I should see {string} within {string}') do |text, parent|
  within(parent) { assert assert_text(text) }
end

Then('I should NOT see {string} within {string}') do |text, parent|
  within(parent) { assert_no_text(text) }
end

Then('I should see {string} before {string}') do |first, second|
  first_index = page.body.index(first)
  raise "#{first} not found" if first_index.blank?

  second_index = page.body.index(second)
  raise "#{second} not found" if second_index.blank?

  assert first_index < second_index
end

Then('I should see {string} before {string} within {string}') do |string1, string2, parent|
  regexp = Regexp.new("#{string1}
#{string2}")
  within(parent) { assert assert_text(regexp) }
end

Then('I should see exactly {int} {string}') do |int, string|
  assert_equal int, page.html.scan(string).count
end

Then('the {string} field should contain {string}') do |field, text|
  assert page.has_field?(field, with: text)
end

Then('{string} should link to {string}') do |link_text, link_url|
  actual = page.find_link(link_text)['href']
  Rails.logger.debug { "link: #{actual} should be #{link_url}" }
  assert_equal link_url, actual
end

Then('{string} should be checked') do |checked|
  Rails.logger.debug { "should be checked: #{checked}" }
  assert page.has_checked_field?(checked)
end

Then('{string} should NOT be checked') do |checked|
  Rails.logger.debug { "should be checked: #{checked}" }
  assert !page.has_checked_field?(checked)
end

Then('nothing should be checked') do
  assert page.has_no_checked_field?
end

Then('the page should NOT contain css {string}') do |field|
  assert !page.has_css?(field)
end

Then('the page should contain css {string}') do |field|
  assert page.has_css?(field)
end

Then('I should NOT see today') do
  assert_no_text(Date.current.to_s)
end

Then('I should see today within {string}') do |string|
  within(string) { assert assert_text(Date.current.to_s) }
end

Then('I should NOT see today within {string}') do |string|
  within(string) { assert assert_no_text(Date.current.to_s) }
end

Then('{string} should be entered in {string}') do |text, field|
  assert page.has_field?(field, with: text)
end

Then('I should NOT have button {string}') do |string|
  Rails.logger.debug { "should not have button: #{string}" }
  assert page.has_no_button?(string)
end

Then('I should have button {string}') do |string|
  Rails.logger.debug { "should have button: #{string}" }
  assert page.has_button?(string)
end

Then('{string} should NOT be entered in {string}') do |text, field|
  assert !page.has_field?(field, with: text)
end

Then('I should see a(n) {word}') do |word|
  raise "#{word} is not what I was expecting" unless %w[notice alert error].include?(word)

  expect(page).to have_css("#flash_#{word}")
end

Then('I should NOT see a(n) {word}') do |word|
  raise "#{word} is not what I was expecting" unless %w[notice alert error].include?(word)

  expect(page).to have_no_css("#flash_#{word}")
end
