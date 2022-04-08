# Givens are data preparation and prerequisite operations.

Given /^I am on (.+)$/ do |the_page|
  visit path_to(the_page)
end
