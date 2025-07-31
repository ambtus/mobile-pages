# frozen_string_literal: true

Then('the page should be hidden') do
  assert Page.first.hidden?
end

Then('{string} should be hidden') do |string|
  assert Page.find_by(title: string).hidden?
end

Then('the page should NOT be hidden') do
  assert !Page.first.hidden?
end

Then('the page should be conned') do
  assert Page.first.con?
end

Then('{string} should be conned') do |string|
  assert Page.find_by(title: string).con?
end

Then('the page should NOT be conned') do
  assert !Page.first.con?
end

Then('{string} should be proed') do |string|
  assert Page.find_by(title: string).pro?
end

Then('the page should NOT be proed') do
  assert !Page.first.pro?
end

Then('the tag_cache should include {string}') do |string|
  tag_cache = Page.first.tag_cache
  assert_match string, tag_cache
end

Then('the tag_cache should NOT include {string}') do |string|
  tag_cache = Page.first.tag_cache
  assert_no_match string, tag_cache
end

Then('I should have {int} hidden pages') do |int|
  assert_equal int, Page.where(hidden: true).count
end
