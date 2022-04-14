# Givens are data preparation and prerequisite operations.

Given /^I am on (.+)$/ do |the_page|
  visit path_to(the_page)
end

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

Given('{string} is a(n) {string}') do |name, type|
  Tag.find_or_create_by!(name: name, type: type)
end

