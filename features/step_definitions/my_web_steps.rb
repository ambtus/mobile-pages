When /^I check boxes "([^\"]*)"$/ do |fields|
  fields.split.each do |field|
    check(field)
  end
end

Then /^"([^"]*)" should be selected in "([^"]*)"$/ do |value, field|
  find_field(field).node.xpath(".//option[@selected = 'selected']").inner_html.should =~ /#{value}/
end

Given /^I wait a second.*$/ do
  Kernel::sleep 1
end

When /^(?:|I )fill in "([^\"]*)" with$/ do |field, value|
  fill_in(field, :with => value)
end

