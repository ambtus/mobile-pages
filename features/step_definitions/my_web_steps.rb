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

Then /I should have a "([^"]*)" field$/ do |field|
  assert has_css?(field)
end

Then /I should not have a "([^"]*)" field$/ do |field|
  assert !has_css?(field)
end

Then /^I should be visiting "([^"]*)"$/ do |link|
  current_url.should == link
end

Then /^I should be visiting "([^"]*)"'s (\d+) pdf page$/ do |title, size|
  page = Page.find_by_title(title)
  current_path.should == page_pdf_path(page.to_param, size)
end
