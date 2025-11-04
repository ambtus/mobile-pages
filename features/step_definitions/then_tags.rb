# frozen_string_literal: true

Then('the tag_cache for {string} should include fandom and author') do |string|
  page = Page.find_by(title: string)
  tag_cache = page.tag_cache
  assert_match 'Harry Potter', tag_cache
  assert_match 'Sidra', tag_cache
end

Then('the tag_cache for {string} should NOT include fandom and author') do |string|
  page = Page.find_by(title: string)
  tag_cache = page.tag_cache
  assert_no_match 'Harry Potter', tag_cache
  assert_no_match 'Sidra', tag_cache
end

Then('the tags for {string} should include fandom and author') do |string|
  page = Page.find_by(title: string)
  assert page.tags.fandoms.include?(fandom)
  assert page.tags.authors.include?(author)
end

Then('the tags for {string} should NOT include fandom and author') do |string|
  page = Page.find_by(title: string)
  Rails.logger.debug { "#{page.tags.map(&:base_name)} should be blank" }
  assert page.tags.empty?
end

Then('the index tags for {string} should include fandom and author') do |string|
  visit filter_path
  fill_in('page_title', with: string)
  click_button('Find')
  # save_and_open_page
  assert_text('Sidra')
  assert_text('Harry Potter')
end

Then('the show tags for {string} should include fandom and author') do |string|
  page = Page.find_by(title: string)
  visit page_path(page)
  assert_text('Sidra')
  assert_text('Harry Potter')
end

Then('the download tag string for {string} should include fandom and author') do |string|
  page = Page.find_by(title: string)
  assert_match 'Harry Potter', page.download_tag_string
  assert_match 'Sidra', page.download_tag_string
end

Then('I can NOT tag {string} with fandom and author') do |string|
  fandom && author
  page = Page.find_by(title: string)
  visit page_path(page)
  within('.meta') { click_link('Tags') }
  within('.form') { assert_no_text('Author:') }
  within('.form') { assert_no_text('Sidra') }
  within('.form') { assert_no_text('Fandom:') }
  within('.form') { assert_no_text('Harry Potter') }
end

Then('I should be able to select {string} from {string}') do |selection, dropdown|
  assert page.has_select?(dropdown, with_options: [selection])
end

Then('I should NOT be able to select {string} from {string}') do |selection, dropdown|
  assert !page.has_select?(dropdown, with_options: [selection])
end

Then('I should have {int} page(s) with and {int} without fandoms') do |wi, wo|
  assert_equal wi, Page.where(fandom: true).count
  assert_equal wo, Page.where(fandom: false).count
end
Then('I should have {int} page(s) with and {int} without authors') do |wi, wo|
  assert_equal wi, Page.where(author: true).count
  assert_equal wo, Page.where(author: false).count
end

Then('I should have {int} tag(s)') do |int|
  expect(Tag.count).to be int
end

Then('{string} should be selected in {string}') do |selected, dropdown|
  assert page.has_select?(dropdown, selected: selected)
end

Then('{string} should NOT be selected in {string}') do |selected, dropdown|
  assert !page.has_select?(dropdown, selected: selected)
end

# Todo move these tests to rspec
Then('the tag_cache should include {string}') do |string|
  tag_cache = Page.first.tag_cache
  assert_match string, tag_cache
end

Then('the tag_cache should NOT include {string}') do |string|
  tag_cache = Page.first.tag_cache
  assert_no_match string, tag_cache
end

Then('the page should be hidden') do
  assert Page.first.hidden?
end

Then('the page should NOT be hidden') do
  assert !Page.first.hidden?
end

Then('the page should be conned') do
  assert Page.first.con?
end

Then('the page should NOT be conned') do
  assert !Page.first.con?
end

Then('I should have no readers') do
  assert_equal 0, Reader.count
end

Then(/^the download epub command should include (.+): "([^"]*)"$/) do |option, text|
  assert Page.first.epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

Then('I should have {int} reading page(s)') do |int|
  Rails.logger.debug { "comparing #{Page.reading.count} with #{int}" }
  assert_equal int, Page.reading.count
end

Then('I should have {int} hidden pages') do |int|
  assert_equal int, Page.where(hidden: true).count
end
