# frozen_string_literal: true

Given('I am on the {word} page') do |word|
  visit "/#{word}"
end

Given('I am on the create single page') do
  visit new_page_path
end

Given('I am on the page with title {string}') do |title|
  page = Page.find_by(title: title)
  raise "no page with title: #{title}" unless page

  visit page_path(page)
end

Given(/^I am on the first page's page$/) do
  page = Page.find_by(title: 'Page 1') || Page.first
  raise 'no pages' unless page

  visit page_path(page)
end

Given(/^I am on the last page's page$/) do
  page = Page.last
  raise 'no pages' unless page

  visit page_path(page)
end

When('I am on the edit tag page for {string}') do |string|
  tag = Tag.find_by(name: string)
  raise "no tag with name: #{string}" unless tag

  visit edit_tag_path(tag)
end

Given(/^I am on the create multiple page$/) do
  visit new_part_path
end

Then('the page should have title {string}') do |string|
  Rails.logger.debug { page.title }
  assert page.has_title? string
end

Then('I should be on the {string} page') do |string|
  assert_equal "/#{string}", page.current_path
end
