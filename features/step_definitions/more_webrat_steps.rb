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

Then /^the field with id "([^\"]*)" should contain "([^\"]*)"$/ do |field_id, value|
      field_with_id(field_id).value.should =~ /#{value}/
  end

Then /^"([^"]*)" should be selected in "([^"]*)"$/ do |value, field_id|
  field_with_id(field_id).element.search(".//option[@selected = 'selected']").inner_html.should =~ /#{value}/
end

Given /^I wait a second.*$/ do
  Kernel::sleep 1
end
