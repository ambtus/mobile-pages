When /^I select "([^\"]*)"$/ do |value|
  select(value)
end

Then /^I should see "([^\"]*)" in "([^\"]*)"$/ do |text, css|
  response.should have_selector(css, :content => text)
end

Then /^I should not see "([^\"]*)" in "([^\"]*)"$/ do |text, css|
  response.should_not have_selector(css, :content => text)
end

When /^I check boxes "([^\"]*)"$/ do |fields|
  fields.split.each do |field|
    check(field)
  end
end

When /^I follow "([^\"]*)" in "([^\"]*)"$/ do |text, css|
  click_link_within(css, text)
end

# can't figure out how to enter a newline without it getting escaped
When /^I fill in "([^\"]*)" with line1: "([^\"]*)" and line2: "([^\"]*)"$/ do |field, line1, line2|
  fill_in(field, :with => [line1, line2].join("\n"))
end
