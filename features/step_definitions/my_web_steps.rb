# TODO: YOU SHOULD DELETE THIS FILE

# If you use these step definitions as basis for your features you will quickly end up
# with features that are:
#
# * Hard to maintain
# * Verbose to read
#
# A much better approach is to write your own higher level step definitions, following
# the advice in the following blog posts:
#
# * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# * http://elabs.se/blog/15-you-re-cuking-it-wrong

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am on (.+)$/ do |the_page|
  visit path_to(the_page)
end

Then("show me the page") do
  save_and_open_page
end

When("I fill in {string} with {string}") do |field, value|
  fill_in(field, :with => value)
end

When("I fill in {string} with") do |field, value|
  fill_in(field, :with => value)
end

Then("the {string} field should contain {string}") do |field, text|
  assert page.has_field?(field, with: text)
end

Then("the {string} field should not contain {string}") do |field, text|
  assert !page.has_field?(field, with: text)
end

When("I select {string} from {string}") do |value, field|
  select(value, :from => field)
end

When("I press {string}") do |button|
  click_button(button)
end

When("I press {string} within {string}") do |button, parent|
  within(parent) { click_button(button) }
end

When("I follow {string}") do |link|
  click_link(link)
end

When("I edit its tags") do
  within(".edits") { click_link("Tags") }
end

When("I follow {string} within {string}") do |link, parent|
  within(parent) { click_link(link) }
end

Then("I should see {string}") do |text|
  assert page.has_content?(text)
end

Then("I should not see {string}") do |text|
  assert_no_text(text)
end

Then("I should see {string} within {string}") do |text, parent|
  within(parent) { assert page.has_content?(text) }
end

Then("I should not see {string} within {string}") do |text, parent|
  within(parent) { assert_no_text(text) }
end

When("I choose {string}") do |field|
  choose(field)
end

When("I choose {string} within {string}") do |field, parent|
  within(parent) { choose(field) }
end

Then("{string} should be selected in {string}") do |selected, dropdown|
  assert page.has_select?(dropdown, selected: selected)
end

Then("I should be able to select {string} from {string}") do |selection, dropdown|
   assert page.has_select?(dropdown, with_options: [selection])
end

Then("I should not be able to select {string} from {string}") do |selection, dropdown|
   assert !page.has_select?(dropdown, with_options: [selection])
end

When("I wait {int} second") do |time|
  Kernel::sleep time
end

When("I view the content") do
  within(".views") {click_link("HTML")}
end
When("I view the content for part {int}") do |int|
  within("#position_#{int}") {click_link("HTML")}
end
When("I want to edit the text") do
  within(".views") {click_link("Text")}
end
When("I download the epub") do
  within(".views") {click_link("ePub")}
end

Then("{string} should link to {string}") do |link_text, link_url|
  assert page.find_link(link_text)['href'] == link_url
end


# When("I go back") do
#   case Capybara::current_driver
#   when :selenium, :webkit
#     page.execute_script('window.history.back()')
#   else
#     if page.driver.respond_to?(:browser)
#       visit page.driver.browser.last_request.env['HTTP_REFERER']
#     else
#       visit page.driver.last_request.env['HTTP_REFERER']
#     end
#   end
# end
