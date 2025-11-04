# frozen_string_literal: true

# TODO: move these tests to rspec
Then('I should have {int} nodes') do |int|
  Rails.logger.debug { "comparing #{Page.first.nodes.count} with #{int}" }
  assert_equal int, Page.first.nodes.count
end
Then('raw should include {string}') do |string|
  assert_match Regexp.new(string), Page.first.raw_html
end

Then('raw should NOT include {string}') do |string|
  assert_no_match Regexp.new(string), Page.first.raw_html
end

Then('edited should include {string}') do |string|
  assert_match Regexp.new(string), Page.first.edited_html
end

Then('edited should NOT include {string}') do |string|
  assert_no_match Regexp.new(string), Page.first.edited_html
end

Then('the contents should include {string}') do |string|
  visit page_path(Page.first)
  click_link 'HTML'
  assert_match Regexp.new(string), Page.first.rendered_html
end

Then('the contents should NOT include {string}') do |string|
  visit page_path(Page.first)
  click_link 'HTML'
  assert_no_match Regexp.new(string), Page.first.rendered_html
end

Then('I should have {int} page(s)') do |int|
  Rails.logger.debug { "currently have #{Page.count} pages" }
  assert_equal int, Page.count
end

Then('my page with title: {string} should have url: {string}') do |title, url|
  page = Page.find_by(title: title)
  raise "couldn't find #{title}" unless page

  Rails.logger.debug { "comparing #{page.url} with #{url}" }
  assert_equal page.url, url
end

Then('my page with url: {string} should have title: {string}') do |url, title|
  page = Page.find_by(url: url)
  Rails.logger.debug { "comparing #{page.title} with #{title}" }
  assert_equal page.title, title
end

Then('Rate {string} should link to its rate page') do |string|
  href = page.find(".rate_#{string.sum}").find_link(string)['href']
  Rails.logger.debug { "link: #{href}" }
  itself = Page.find_by(title: string)
  assert_match "/rates/#{itself.id}", href
end

Then('{string} should be a {string}') do |string, string2|
  page = Page.find_by(title: string)
  Rails.logger.debug { "comparing #{page.type} with #{string2}" }
  assert_equal string2, page.type
end

Then('{string} should link to itself') do |string|
  itself = Page.find_by(title: string) || Page.find_by(title: string.partition('. ').last)
  href = page.find("##{itself.header_id}").find_link(string)['href']
  Rails.logger.debug { "link: page #{itself.id} should be at #{href}" }
  assert_match "/pages/#{itself.id}", href
end

Then('{string} should have {int} horizontal rules') do |string, int|
  page = Page.find_by(title: string)
  assert_equal int, page.scrubbed_html.scan('<hr').count
end

Then('the contents should start with {string}') do |string|
  assert_match Regexp.new("^<p>#{string}"), Page.first.scrubbed_html
end
Then('the contents should end with {string}') do |string|
  assert_match Regexp.new("#{string}</p>$"), Page.first.scrubbed_html
end

Then('Next should link to the content for {string}') do |string|
  next_page = Page.find_by(title: string)
  page_contents_url = next_page.download_url('.html')
  Rails.logger.debug { "#{string} link: #{page_contents_url}" }
  href = page.find('.next').find_link(next_page.title)['href']
  Rails.logger.debug { "Next link: #{href}" }
  assert_match page_contents_url, href
end

Then('{string} should be {string} soon') do |string, string2|
  page = Page.find_by(title: string)
  Rails.logger.debug { "comparing #{page.soon} with #{string2}" }
  assert_equal page.soon_label, string2
end

Then('all pages should be rated {int}') do |int|
  assert_equal Page.all.map(&:stars).uniq, [int]
end

Then('the part titles should be stored as {string}') do |title_string|
  assert_equal Page.with_parts.first.parts.map(&:title).join(' & '), title_string
end

Then('my page with title: {string} should not have a parent') do |string|
  assert_nil Page.find_by(title: string).parent
end

Then('my page with title: {string} should have {int} parts') do |string, int|
  assert_equal Page.find_by(title: string).parts.size, int
end

Then('the read after date for {string} should be today') do |title|
  page = Page.find_by(title: title)
  Rails.logger.debug { "comparing #{page.read_after.to_date} with #{Date.current}" }
  assert_equal page.read_after.to_date, Date.current
end

Then('the read after date for {string} should be {string}') do |title, date|
  page = Page.find_by(title: title)
  Rails.logger.debug { "comparing #{page.read_after.to_date} with #{date}" }
  assert_equal page.read_after.to_date.to_s, date
end
