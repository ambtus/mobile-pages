## Whens are the web actions: click, enter, press, follow
# And page actions: edit the notes/title/url

## Web whens
When("I press {string}") do |button|
  click_button(button)
end

When("I follow {string}") do |link|
  click_link(link)
end

When("I choose {string}") do |field|
  choose(field)
end

When("I wait {int} second") do |time|
  Kernel::sleep time
end

## Page whens (TODO: move to pages.rb?)

When("I edit its tags") do
  within(".edits") { click_link("Tags") }
end

## TODO rewrite: I edit the text
When("I want to edit the text") do
  within(".views") {click_link("Text")}
end

When("I view the content") do
  within(".views") {click_link("HTML")}
end

When("I view the content for part {int}") do |int|
  within("#position_#{int}") {click_link("HTML")}
end

When("I download the epub") do
  within(".views") {click_link("ePub")}
end


## FIXME "A step description should never contain regexen, CSS or XPath selectors, any kind of code or data structure." ~JONAS NICKLAS

When("I fill in {string} with {string}") do |field, value|
  fill_in(field, :with => value)
end

When("I fill in {string} with") do |field, value|
  fill_in(field, :with => value)
end

When("I select {string} from {string}") do |value, field|
  select(value, :from => field)
end

When("I press {string} within {string}") do |button, parent|
  within(parent) { click_button(button) }
end

When("I follow {string} within {string}") do |link, parent|
  within(parent) { click_link(link) }
end

When("I choose {string} within {string}") do |field, parent|
  within(parent) { choose(field) }
end

