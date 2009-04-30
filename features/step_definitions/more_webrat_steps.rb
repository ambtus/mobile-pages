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
