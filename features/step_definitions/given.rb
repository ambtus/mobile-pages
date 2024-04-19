# Givens are data preparation and prerequisite operations.

Given /^I am on (.+)$/ do |the_page|
  visit path_to(the_page)
end

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

Given('{string} is a(n) {string}') do |name, type|
  Rails.logger.debug "creating #{type} with name #{name}"
  Tag.find_or_create_by!(name: name, type: type)
end

Given("{string} is a cliffhanger") do |title|
  page = Page.find_by title: title
  raise "no page with title #{title}" unless page
  page.update_cliff('Yes')
end

Given("{string} is unfinished") do |title|
  page = Page.find_by title: title
  raise "no page with title #{title}" unless page
  page.update_unfinished('Yes')
end

Given('a test page exists') do
  page = Single.create(title: "Test", url: "file:///#{Rails.root}/tmp/html/short.html")
  page.update url: "http://test.sidrasue.com/short.html"
end
