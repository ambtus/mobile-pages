# frozen_string_literal: true

Given(/^I am on the homepage$/) do
  # FIXME
  # this isn't actually the homepage
  # all the tests need to be rewritten
  visit '/pages'
end

Given('I am on the {word} page') do |word|
  visit "/#{word}"
end

Given(/^I am on the {string} page$/) do |string|
  path_components = string.split(/\s+/)
  visit path_components.push('path').join('_').to_sym
end

Given('I am on the create single page') do
  visit new_page_path
end

Given(/^I am on the create multiple page$/) do
  visit new_part_path
end

Given(/^I am on the first page's page$/) do
  page = Page.find_by(title: 'Page 1') || Page.first
  raise 'no pages' unless page

  visit page_path(page)
end

Given("I am on the page with title {string}") do |title|
  page = Page.find_by(title: title)
  raise "no page with title: #{title}" unless page

  visit page_path(page)
end

Given("I am on the page with url {string}") do |url|
  page = Page.find_by(url: url)
  raise "no page with url: #{url}" unless page

  visit page_path(page)
end

Given("I am on the edit tag page for {string}") do |name|
 tag = Tag.find_by(name: name)
  raise "no tag with name: #{name}" unless tag
  visit edit_tag_path(tag)
end



