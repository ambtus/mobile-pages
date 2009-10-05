Given /^I have no filters$/ do
  Author.delete_all
  Genre.delete_all
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
