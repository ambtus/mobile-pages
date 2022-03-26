Then("I have no tags") do
  Tag.delete_all
end

Then("I have no omitteds") do
  Hidden.delete_all
end

Then("I have no fandoms") do
  Fandom.delete_all
end

Then("I should have no tags") do
  assert Tag.count == 0
end

Then("I should have no hiddens") do
  assert Hidden.count == 0
end

Then("I should have no infos") do
  assert Info.count == 0
end

Then("I should have no fandoms") do
  assert Fandom.count == 0
end

Then("I should have no omitteds") do
  assert Omitted.count == 0
end

Then("I should have no ratings") do
  assert Rating.count == 0
end

Then("I should have no characters") do
  assert Character.count == 0
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

Then("the page should NOT have any not info tags") do
  Page.first.tags.not_info.empty?
end

Then("the page should NOT have any info tags") do
  Page.first.tags.info.empty?
end

Then("the page should NOT have any not hidden tags") do
  Page.first.tags.not_hidden.empty?
end

Then("the page should NOT have any hidden tags") do
  Page.first.tags.hidden.empty?
end

Then("the page should NOT have any fandom tags") do
  Page.first.fandoms.empty?
end

Then("the page should NOT have any character tags") do
  Page.first.tags.character.empty?
end

Then("the page should NOT have any rating tags") do
  Page.first.tags.rating.empty?
end

Then("the page should NOT have any not character tags") do
  Page.first.tags.not_character.empty?
end

Then("the page should NOT have any not rating tags") do
  Page.first.tags.not_rating.empty?
end

Then("the page should NOT have any omitted tags") do
  Page.first.tags.omitted.empty?
end

Then("the page should NOT have any not omitted tags") do
  Page.first.tags.not_omitted.empty?
end
