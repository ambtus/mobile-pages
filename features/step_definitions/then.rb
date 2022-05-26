## Thens are for verifications and assertions

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

Then('I should see today within {string}') do |string|
  within(string) { assert assert_text(Date.current.to_s) }
end

Then('I should NOT see today within {string}') do |string|
  within(string) { assert assert_no_text(Date.current.to_s)}
end

Then('I should NOT see today') do
  assert_no_text(Date.current.to_s)
end

## I should have ##

Then("I should have no authors") do
  assert Author.count == 0
end

Then('I should have {int} tag(s)') do |int|
  Rails.logger.debug "curent tags: #{Tag.all.map(&:name)}"
  assert Tag.count==int
end

## It should

Then('the page should have title {string}') do |string|
  Rails.logger.debug page.title
  assert page.has_title? string
end

Then("{string} should link to {string}") do |link_text, link_url|
  actual = page.find_link(link_text)['href']
  Rails.logger.debug "link: #{actual} should be #{link_url}"
  assert actual == link_url
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

## selections and check

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

