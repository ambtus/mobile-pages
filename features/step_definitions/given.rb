# frozen_string_literal: true

# Givens are data preparation and prerequisite operations.

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

Given('{string} is a(n) {string}') do |name, type|
  Rails.logger.debug { "creating #{type} with name #{name}" }
  Tag.find_or_create_by!(name: name, type: type)
end

Given('the tag {string} is destroyed without caching') do |string|
  tag = Tag.find_by(name: string)
  tag.destroy
end

Given('the page has url: {string}') do |string|
  page = Page.first
  page.update!(url: string)
end
