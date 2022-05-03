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

When("I edit its tags") do
  within(".meta") { click_link("Tags") }
end

## TODO - make the following match "I edit its tags"
## its NOT the
When("I edit the text") do
  within(".views") {click_link("Text")}
end
When("I download the epub") do
  within(".views") {click_link("ePub")}
end
When("I view the content") do
  within(".views") {click_link("HTML")}
end

When("I add a parent with title {string}") do |title|
  within(".content") { click_link("Add Parent")}
  fill_in("add_parent", :with => title)
  click_button("Add")
end

When("I change the title to {string}") do |title|
  within(".meta") { click_link("Title")}
  fill_in("title", :with => title)
  click_button("Update")
end

When("I refetch the following") do |value|
  within(".content") { click_link("Refetch")}
  fill_in("url_list", :with => value)
  click_button("Refetch")
end

When("I view the content for part {int}") do |int|
  within("#position_#{int}") {click_link("HTML")}
end

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


