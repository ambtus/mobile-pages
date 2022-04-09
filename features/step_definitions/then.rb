## Thens are for verifications and assertions
# Primarily "I should see"
# But sometimes "I should have"

## I should see ##
Then("show me the page") do
  save_and_open_page
end

Then("I should see {string}") do |text|
  assert_text(text)
end

Then("I should NOT see {string}") do |text|
  assert_no_text(text)
end

## FIXME rewrite: I should see {string} before {string}
Then("{string} should come before {string}") do |first, second|
  assert page.body.index(first) < page.body.index(second)
end

## FIXME rewrite: I should see a horizontal rule
Then('there should be a horizontal rule') do
  assert page.html.include?('<hr>')
end

## FIXME rewrite: I should NOT see a horizontal rule
Then('there should NOT be a horizontal rule') do
  assert !page.html.include?('<hr>')
end

## I should have ##

Then("I should have no authors") do
  assert Author.count == 0
end

Then('I should have {int} page(s)') do |int|
  Rails.logger.debug "DEBUG: currently have #{Page.count} pages"
  assert Page.count == int
end

Then('I should have {int} tag(s)') do |int|
  Rails.logger.debug "DEBUG: curent tags: #{Tag.all.map(&:name)}"
  assert Tag.count==int
end

## other shoulds ##

Then('{string} should link to itself') do |string|
  href = page.find_link(string)['href']
  itself = Page.find_by_title(string)
  Rails.logger.debug "DEBUG: link: page #{itself.id} should be at #{href}"
  assert href == "/pages/#{itself.id}"
end

## FIXME "A step description should never contain regexen, CSS or XPath selectors, any kind of code or data structure." ~JONAS NICKLAS

Then("the {string} field should contain {string}") do |field, text|
  assert page.has_field?(field, with: text)
end

Then("the {string} field should NOT contain {string}") do |field, text|
  assert !page.has_field?(field, with: text)
end

Then("the page should NOT contain css {string}") do |field|
  assert !page.has_css?(field)
end

Then("I should see {string} within {string}") do |text, parent|
  within(parent) { assert assert_text(text) }
end

Then("I should NOT see {string} within {string}") do |text, parent|
  within(parent) { assert_no_text(text) }
end

Then('I should see {string} before {string} within {string}') do |string1, string2, parent|
  text = Regexp.new(string1 + '
' + string2)
  within(parent) { assert assert_text(text) }
end

Then('I should NOT see {string} before {string} within {string}') do |string1, string2, parent|
  text = Regexp.new(string1 + '
' + string2)
  within(parent) { assert_no_text(text) }
end

Then("{string} should be selected in {string}") do |selected, dropdown|
  assert page.has_select?(dropdown, selected: selected)
end

Then("I should be able to select {string} from {string}") do |selection, dropdown|
   assert page.has_select?(dropdown, with_options: [selection])
end

Then("I should NOT be able to select {string} from {string}") do |selection, dropdown|
   assert !page.has_select?(dropdown, with_options: [selection])
end

Then("{string} should be checked") do |checked|
  Rails.logger.debug "DEBUG: should be checked: #{checked}"
  assert page.has_checked_field?(checked)
end

Then("nothing should be checked") do
  assert page.has_no_checked_field?
end

Then("{string} should link to {string}") do |link_text, link_url|
  actual = page.find_link(link_text)['href']
  Rails.logger.debug "DEBUG: link: #{actual} should be #{link_url}"
  assert actual == link_url
end

Then('the page should have title {string}') do |string|
  assert page.has_title? string
end

Then /^my page named "([^\"]*)" should contain "([^\"]*)"$/ do |title, string|
  assert_match Regexp.new(string), Page.find_by_title(title).edited_html
end
Then /^my page named "([^\"]*)" should NOT contain "([^\"]*)"$/ do |title, string|
  assert_no_match Regexp.new(string), Page.find_by_title(title).edited_html
end

Then('my page named {string} should have {int} parts') do |string, int|
  assert Page.find_by_title(string).parts.size == int
end

Then("last read should be today") do
  Rails.logger.debug "DEBUG: comparing #{Page.first.last_read.to_date} with #{Date.current}"
  assert Page.first.last_read.to_date == Date.current
end

Then('I should see today within {string}') do |string|
  within(string) { assert assert_text(Date.current.to_s) }
end

Then('I should NOT see today within {string}') do |string|
  within(string) { assert assert_no_text(Date.current.to_s)}
end

Then('I should NOT see today') do
  assert_no_text(Date.current.to_s)
end


Then("the part titles should be stored as {string}") do |title_string|
   assert Page.first.parts.map(&:title).join(" & ") == title_string
end

Then('the read after date should be {int} year(s) from now') do |int|
  diff = Page.first.read_after.year - Date.today.year
  Rails.logger.debug "DEBUG: comparing #{Page.first.read_after.year} with #{Date.today.year} (#{diff})"
  assert diff == int
end

Then('the read after date should be 6 months from now') do
  diff = Page.first.read_after.month - Date.today.month
  Rails.logger.debug "DEBUG: comparing #{Page.first.read_after.year} with #{Date.today.year} (#{diff})"
  assert diff.abs == 6
end

Then('the read after date should be {string}') do |string|
  Rails.logger.debug "DEBUG: comparing #{Page.first.read_after} with #{string}"
  assert Page.first.read_after == string
end

Then('my page named {string} should have url: {string}') do |title, url|
  page = Page.find_by_title(title)
  Rails.logger.debug "DEBUG: comparing #{page.url} with #{url}"
  assert page.url == url
end

Then('the notes should NOT include {string}') do |string|
  assert_no_match Regexp.new(string), Page.first.notes
end

Then('the notes should include {string}') do |string|
  assert_match Regexp.new(string), Page.first.notes
end
