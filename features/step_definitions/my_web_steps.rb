Then /^"([^"]*)" should be selected in "([^"]*)"$/ do |selected, dropdown|
  assert page.has_select?(dropdown, selected: selected)
end

Given /^(?:|I )wait (\d+) second.?$/ do |time|
  Kernel::sleep time.to_i
end

When /^(?:|I )fill in "([^\"]*)" with$/ do |field, value|
  fill_in(field, :with => value)
end

When("I view the HTML") do
  click_link("HTML")
end


Then /^(?:|I )should not have a "([^"]*)" field$/ do |field|
  assert !has_css?(field)
end

Then /^"([^\"]*)" should link to "([^\"]*)"$/ do |link_text, link_url|
  assert page.find_link(link_text)['href'] == link_url
end

Then /^show me the page$/ do
  save_and_open_page
end

When /^I go back$/ do
  case Capybara::current_driver
  when :selenium, :webkit
    page.execute_script('window.history.back()')
  else
    if page.driver.respond_to?(:browser)
      visit page.driver.browser.last_request.env['HTTP_REFERER']
    else
      visit page.driver.last_request.env['HTTP_REFERER']
    end
  end
end
