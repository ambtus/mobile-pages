Given /^I have no authors$/ do
  Author.delete_all
end

# create an author
Given /an author exists(?: with (.*))?/ do |fields|
  fields.blank? ? hash = {} : hash = fields.create_hash
  hash[:name] = hash[:name] || "Author 1"
  Rails.logger.debug "DEBUG: creating author with hash: #{hash}"
  Author.create(hash)
end

# create multiple authors
Given /^the following authors?$/ do |table|
  Author.delete_all
  # table is a Cucumber::Ast::Table
  table.hashes.each { |hash| Author.create(hash) }
end

