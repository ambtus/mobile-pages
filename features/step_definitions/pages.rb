Given /^I have no pages$/ do
  Page.delete_all
end

Given /^the following pages$/ do |table|
  Page.delete_all
  # table is a Cucumber::Ast::Table
  table.hashes.each {|hash| Page.create!(hash)}
end
