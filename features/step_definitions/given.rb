# frozen_string_literal: true

# Givens are data preparation and prerequisite operations.

Given(/^I am on (.+)$/) do |the_page|
  visit path_to(the_page)
end

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

Given('{string} is a(n) {string}') do |name, type|
  Rails.logger.debug { "creating #{type} with name #{name}" }
  Tag.find_or_create_by!(name: name, type: type)
end

Given('a test page exists') do
  page = Single.create(title: 'Test', url: "file:///#{Rails.root.join('tmp/html/short.html')}")
  page.update url: 'http://test.sidrasue.com/short.html'
end

Given('the tag {string} is destroyed without caching') do |string|
  tag = Tag.find_by(name: string)
  tag.destroy
end

Given('the page has url: {string}') do |string|
  page = Page.first
  page.update!(url: string)
end
