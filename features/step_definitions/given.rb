# Givens are data preparation and prerequisite operations.

Given /^I am on (.+)$/ do |the_page|
  visit path_to(the_page)
end

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end


## FIXME rewrite: an author exists with name: "Sidra"
# as
# {string} is an author
Given /an author exists(?: with (.*))?/ do |fields|
  fields.blank? ? hash = {} : hash = fields.create_hash
  hash[:name] = hash[:name] || "Author 1"
  Rails.logger.debug "DEBUG: creating author with hash: #{hash}"
  Author.create(hash)
end


## FIXME "A step description should never contain regexen, CSS or XPath selectors, any kind of code or data structure." ~JONAS NICKLAS

# create a tag
Given /a tag exists(?: with (.*))?/ do |fields|
  fields.blank? ? hash = {} : hash = fields.create_hash
  hash[:name] = hash[:name] || "Tag 1"
  Rails.logger.debug "DEBUG: creating tag with hash: #{hash}"
  Tag.create(hash)
end

