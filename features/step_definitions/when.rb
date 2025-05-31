## Whens are the web actions: click, enter, press, follow

When("I wait {int} second") do |time|
  Kernel::sleep time
end

When('I submit the form') do
  click_button
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

When("I follow {string} within {string}") do |link, parent|
  within(parent) { click_link(link) }
end

When("I click on {string}") do |field|
  choose(field)
end

When("I click on {string} within {string}") do |field, parent|
  within(parent) { choose(field) }
end

When("I select {string}") do |value|
  select(value)
end

When("I unselect {string}") do |value|
  unselect(value)
end

When("I select {string} from {string}") do |value, field|
  select(value, :from => field)
end

When("I fill in {string} with {string}") do |field, value|
  fill_in(field, :with => value)
end

When("I fill in {string} with") do |field, value|
  fill_in(field, :with => value)
end

When("I check {string}") do |value|
  check(value)
end

When('I enter raw html for {string}') do |string|
  fill_in("pasted", :with => File.read(Rails.root + "tmp/html/#{string}.html"))
end
