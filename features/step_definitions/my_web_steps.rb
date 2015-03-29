Then /^"([^"]*)" should be selected in "([^"]*)"$/ do |value, field|
   find_field(field).value.should =~ /#{value}/
end

Given /^(?:|I )wait (\d+) second.?$/ do |time|
  Kernel::sleep time.to_i
end

When /^(?:|I )fill in "([^\"]*)" with$/ do |field, value|
  fill_in(field, :with => value)
end

Then /^(?:|I )should not have a "([^"]*)" field$/ do |field|
  assert !has_css?(field)
end

Then /^"([^\"]*)" should link to "([^\"]*)"$/ do |link_text, link_url|
  page.find_link(link_text)['href'].should == link_url
end

Then /^show me the page$/ do
  save_and_open_page
end
