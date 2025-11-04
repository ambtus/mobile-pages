# frozen_string_literal: true

When('I tag {string} with fandom and author') do |string|
  fandom && author
  page = Page.find_by(title: string)
  visit page_path(page)
  within('.meta') { click_link('Tags') }
  select('Harry Potter')
  select('Sidra')
  click_button('Update Tags')
end

When('I edit its tags') do
  within('.meta') { click_link('Tags') }
end
