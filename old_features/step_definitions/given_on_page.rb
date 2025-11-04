# frozen_string_literal: true

Given(/^I am on the {string} page$/) do |string|
  path_components = string.split(/\s+/)
  visit path_components.push('path').join('_').to_sym
end

Given('I am on the page with url {string}') do |url|
  page = Page.find_by(url: url)
  raise "no page with url: #{url}" unless page

  visit page_path(page)
end

Given('I am on the edit tag page for {string}') do |name|
  tag = Tag.find_by(name: name)
  raise "no tag with name: #{name}" unless tag

  visit edit_tag_path(tag)
end
