Given /^I have no authors$/ do
  Author.delete_all
end

Given /^I have no genres$/ do
  Genre.delete_all
end

Given /^I have no hiddens$/ do
  Hidden.delete_all
end

Given /^the following authors?$/ do |table|
  Author.delete_all
  # table is a Cucumber::Ast::Table
  table.hashes.each { |hash| Author.create(hash) }
end

Given /^the following genres?$/ do |table|
  Genre.delete_all
  # table is a Cucumber::Ast::Table
  table.hashes.each { |hash| Genre.create(hash) }
end

Then /^I should have no genres$/ do
  assert Genre.count == 0
end

Then /^I should have no hiddens$/ do
  assert Hidden.count == 0
end
