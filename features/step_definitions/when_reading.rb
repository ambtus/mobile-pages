# frozen_string_literal: true

When('I read it online') do
  page = Page.first
  raise 'no pages' unless page

  visit page_path(page)
  within('.views') { click_link('HTML') }
end

When('I read {string} online') do |title|
  page = Page.find_by title: title
  raise "no page with title #{title}" unless page

  visit page_path(page)
  within('.views') { click_link('HTML') }
end

When('I download its epub') do
  page = Page.first
  raise 'no pages' unless page

  visit page_path(page)
  within('.views') { click_link('ePub') }
end

When('I download the epub for {string}') do |title|
  page = Page.find_by title: title
  raise "no page with title #{title}" unless page

  visit page_path(page)
  within('.views') { click_link('ePub') }
end

When('I view the text for reading aloud') do
  page = Page.with_content.first
  raise 'no pages that can be read aloud' unless page

  visit page_path(page)
  within('.views') { click_link('Read') }
end

Then('Leave Kudos or Comments on {string} should link to its comments') do |string|
  href = page.find('.kudos').find_link(string)['href']
  Rails.logger.debug { "link: #{href}" }
  itself = Page.find_by(title: string)
  assert_equal "#{itself.url}#comments", href
end

Then('Leave Kudos or Comments on {string} should link to the last chapter comments') do |string|
  href = page.find('.kudos').find_link(string)['href']
  Rails.logger.debug { "link: #{href}" }
  last_page = Page.find_by(title: string).parts.last
  assert_equal "#{last_page.url}#comments", href
end
