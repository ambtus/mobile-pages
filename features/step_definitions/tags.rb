Given /^I have no tags$/ do
  Tag.delete_all
end

Then /^I should have no tags$/ do
  assert Tag.count == 0
end

Given /^I have no hiddens$/ do
  Hidden.delete_all
end

Then /^I should have no hiddens$/ do
  assert Hidden.count == 0
end

# create a tag
Given /a tag exists(?: with (.*))?/ do |fields|
  fields.blank? ? hash = {} : hash = fields.create_hash
  hash[:name] = hash[:name] || "Tag 1"
  Rails.logger.debug "DEBUG: creating tag with hash: #{hash}"
  Tag.create(hash)
end

# create multiple tags
Given /^the following tags?$/ do |table|
  Tag.delete_all
  # table is a Cucumber::Ast::Table
  table.hashes.each { |hash| Tag.create(hash) }
end

