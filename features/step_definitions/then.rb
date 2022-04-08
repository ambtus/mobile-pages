## Thens are for verifications and assertions
# Primarily "I should see"
# But sometimes "I should have"

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

