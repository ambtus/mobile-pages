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

Then("I should see {string} before {string}") do |first, second|
  assert page.body.index(first) < page.body.index(second)
end

Then('I should see a horizontal rule') do
  assert page.html.include?('<hr>')
end

Then('I should see two horizontal rules') do
  assert Regexp.new(/<hr>.*<hr>/).match(page.html.squish)
end

Then('I should NOT see a horizontal rule') do
  assert !page.html.include?('<hr>')
end

Then('I should NOT see two horizontal rules') do
  assert !Regexp.new(/<hr>.*<hr>/).match(page.html.squish)
end

## I should have ##

Then("I should have no authors") do
  assert Author.count == 0
end

Then('I should have {int} page(s)') do |int|
  Rails.logger.debug "currently have #{Page.count} pages"
  assert Page.count == int
end

Then('I should have {int} tag(s)') do |int|
  Rails.logger.debug "curent tags: #{Tag.all.map(&:name)}"
  assert Tag.count==int
end

## other shoulds ##

Then('{string} should link to itself') do |string|
  href = page.find_link(string)['href']
  itself = Page.find_by_title(string)
  Rails.logger.debug "link: page #{itself.id} should be at #{href}"
  assert_match "/pages/#{itself.id}", href
end

Then('Leave Kudos or Comments on {string} should link to its comments') do |string|
  href = page.find_link("Leave Kudos or Comments on \"#{string}\"")['href']
  Rails.logger.debug "link: #{href}"
  itself = Page.find_by_title(string)
  assert href == itself.url + "#comments"
end

Then('Rate {string} should link to its rate page') do |string|
  href = page.find_link("Rate \"#{string}\"")['href']
  Rails.logger.debug "link: #{href}"
  itself = Page.find_by_title(string)
  assert_match "/rates/#{itself.id}", href
end

Then('{string} should link to the content for {string}') do |string1, string2|
  href = page.find_link(string1)['href']
  Rails.logger.debug "#{string1} link: #{href}"
  page_contents_url = Page.find_by_title(string2).download_url(".html")
  Rails.logger.debug "#{string2} link: #{page_contents_url}"
  assert href == page_contents_url
end


Then("the {string} field should contain {string}") do |field, text|
  assert page.has_field?(field, with: text)
end

Then("the {string} field should NOT contain {string}") do |field, text|
  assert !page.has_field?(field, with: text)
end

Then("the page should NOT contain css {string}") do |field|
  assert !page.has_css?(field)
end

Then("the page should contain css {string}") do |field|
  assert page.has_css?(field)
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

Then("{string} should NOT be selected in {string}") do |selected, dropdown|
  assert !page.has_select?(dropdown, selected: selected)
end

Then("I should be able to select {string} from {string}") do |selection, dropdown|
   assert page.has_select?(dropdown, with_options: [selection])
end

Then("I should NOT be able to select {string} from {string}") do |selection, dropdown|
   assert !page.has_select?(dropdown, with_options: [selection])
end

Then("{string} should be checked") do |checked|
  Rails.logger.debug "should be checked: #{checked}"
  assert page.has_checked_field?(checked)
end

Then("{string} should NOT be checked") do |checked|
  Rails.logger.debug "should be checked: #{checked}"
  assert !page.has_checked_field?(checked)
end

Then("nothing should be checked") do
  assert page.has_no_checked_field?
end

Then("{string} should link to {string}") do |link_text, link_url|
  actual = page.find_link(link_text)['href']
  Rails.logger.debug "link: #{actual} should be #{link_url}"
  assert actual == link_url
end

Then('the page should have title {string}') do |string|
  assert page.has_title? string
end

Then('the contents should include {string}') do |string|
  assert_match Regexp.new(string), Page.first.all_html
end

Then('the contents should NOT include {string}') do |string|
  assert_no_match Regexp.new(string), Page.first.all_html
end

Then('my page named {string} should have {int} parts') do |string, int|
  assert Page.find_by_title(string).parts.size == int
end

Then("last read should be today") do
  Rails.logger.debug "comparing #{Page.first.last_read.to_date} with #{Date.current}"
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
  Rails.logger.debug "comparing #{Page.first.read_after.year} with #{Date.today.year} (#{diff})"
  assert diff == int
end

Then('the read after date should be 6 months from now') do
  diff = Page.first.read_after.month - Date.today.month
  Rails.logger.debug "comparing #{Page.first.read_after.year} with #{Date.today.year} (#{diff})"
  assert diff.abs == 6
end

Then('the read after date should be {string}') do |string|
  Rails.logger.debug "comparing #{Page.first.read_after} with #{string}"
  assert Page.first.read_after == string
end

Then('the read after date for {string} should be {string}') do |title, date|
  page = Page.find_by_title(title)
  Rails.logger.debug "comparing #{page.read_after.to_date} with #{date}"
  assert page.read_after == date
end

Then('the read after date for {string} should be today') do |title|
  page = Page.find_by_title(title)
  Rails.logger.debug "comparing #{page.read_after.to_date} with #{Date.current}"
  assert page.read_after.to_date == Date.current
end

Then('my page named {string} should have url: {string}') do |title, url|
  page = Page.find_by_title(title)
  Rails.logger.debug "comparing #{page.url} with #{url}"
  assert page.url == url
end

Then('the notes should NOT include {string}') do |string|
  assert_no_match Regexp.new(string), Page.first.notes
end

Then('the notes should include {string}') do |string|
  assert_match Regexp.new(string), Page.first.notes
end

Then('the notes should be empty') do
  assert Page.first.notes.blank?
end
