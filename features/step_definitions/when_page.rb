# frozen_string_literal: true

When('I change its raw html to') do |multi_line|
  html = multi_line.inspect.strip_quotes
  step "I change its raw html to \"#{html}\""
end

When('I change its scrubbed html to') do |multi_line|
  html = multi_line.inspect.strip_quotes
  step "I change its scrubbed html to \"#{html}\""
end

When('I change its raw html to {string}') do |html|
  page = Page.with_content.first
  raise 'no pages that can edit raw html' unless page

  visit page_path(page)
  click_link 'Edit Raw HTML'
  fill_in 'pasted', with: html
  Rails.logger.debug { "changing raw html to: #{html}" }
  click_button 'Update Raw HTML'
end

When('I change the raw html for {string} to {string}') do |title, html|
  page = Page.find_by title: title
  raise 'no pages' unless page

  visit page_path(page)
  click_link 'Edit Raw HTML'
  fill_in 'pasted', with: html
  click_button 'Update Raw HTML'
end

When('I edit the raw html with {string}') do |string|
  click_link('Edit Raw HTML')
  fill_in('pasted', with: get_raw_from(string))
  click_button('Update Raw HTML')
end

When('I store the raw html from {string}') do |string|
  fill_in('pasted', with: get_raw_from(string))
  click_button('Update Raw HTML')
end

When('I change its scrubbed html to {string}') do |html|
  page = Page.with_content.first
  raise 'no pages that can edit scrubbed html' unless page

  visit page_path(page)
  click_link 'Edit Scrubbed HTML'
  fill_in 'pasted', with: html
  Rails.logger.debug { "changing scrubbed html to: #{html}" }
  click_button 'Edit HTML'
end

When('I add a parent with title {string}') do |title|
  click_link('Add Parent')
  fill_in('add_parent', with: title)
  click_button('Add')
end

When('I refetch it with url: {string}') do |string|
  step %(I am on the first page's page)
  click_link('Refetch')
  fill_in(:url, with: string)
  click_button('Refetch')
  if page.text.match? %(couldn't resolve host name)
    skip_this_scenario 'This is a pending scenario because the network is down'
  end
end

When('I refetch it') do
  step %(I am on the first page's page)
  click_link('Refetch')
  click_button('Refetch')
  if page.text.match? %(couldn't resolve host name)
    skip_this_scenario 'This is a pending scenario because the network is down'
  end
end

When('I refetch it from mini') do
  visit '/mini'
  fill_in(:page_url, with: Page.first.url)
  click_button('Refetch')
  if page.text.match? %(couldn't resolve host name)
    skip_this_scenario 'This is a pending scenario because the network is down'
  end
end

When('I refetch the following') do |value|
  within('.content') { click_link('Refetch') }
  fill_in('url_list', with: value)
  click_button('Refetch')
  if page.text.match? %(couldn't resolve host name)
    skip_this_scenario 'This is a pending scenario because the network is down'
  end
end

When('I store the page without refetching') do
  click_button('Store w/o Fetching')
end

When('I change the url to {string} without refetching') do |string|
  click_link('Refetch')
  fill_in(:url, with: string)
  click_button('Store w/o Fetching')
end

When('I store the page') do
  click_button('Store')
  if page.text.match? %(couldn't resolve host name)
    skip_this_scenario 'This is a pending scenario because the network is down'
  end
end

When('I follow the link for {string}') do |string|
  page = Page.find_by title: string
  click_link("/pages/#{page.id}")
end

When('I change the title to {string}') do |title|
  within('.meta') { click_link('Title') }
  fill_in('title', with: title)
  click_button('Update')
end
