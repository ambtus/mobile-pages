# frozen_string_literal: true

When('I rate it {int} stars') do |int|
  page = Page.first
  raise "no page with title #{title}" unless page

  visit page_path(page)
  click_link('Rate')
  choose(int.to_s)
  click_button('Rate')
end
