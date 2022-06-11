## thens which call the Page model ##

Then('I should have {int} page(s)') do |int|
  Rails.logger.debug "currently have #{Page.count} pages"
  assert_equal int, Page.count
end


Then('{string} should link to itself') do |string|
  href = page.find_link(string)['href']
  itself = Page.find_by_title(string)
  Rails.logger.debug "link: page #{itself.id} should be at #{href}"
  assert_match "/pages/#{itself.id}", href
end

Then('Leave Kudos or Comments on {string} should link to its comments') do |string|
  href = page.find(".kudos").find_link(string)['href']
  Rails.logger.debug "link: #{href}"
  itself = Page.find_by_title(string)
  assert_equal itself.url + "#comments", href
end

Then('Leave Kudos or Comments on {string} should link to the last chapter comments') do |string|
  href = page.find(".kudos").find_link(string)['href']
  Rails.logger.debug "link: #{href}"
  last_page = Page.find_by_title(string).parts.last
  assert_equal last_page.url + "#comments", href
end

Then('Rate {string} should link to its rate page') do |string|
  href = page.find(".rate").find_link(string)['href']
  Rails.logger.debug "link: #{href}"
  itself = Page.find_by_title(string)
  assert_match "/rates/#{itself.id}", href
end

Then('Next should link to the content for {string}') do |string|
  next_page = Page.find_by_title(string)
  page_contents_url = next_page.download_url(".html")
  Rails.logger.debug "#{string} link: #{page_contents_url}"
  href = page.find(".next").find_link(next_page.title)['href']
  Rails.logger.debug "Next link: #{href}"
  assert_match page_contents_url, href
end

Then('the contents should include {string}') do |string|
  assert_match Regexp.new(string), Page.first.all_html
end

Then('the contents should NOT include {string}') do |string|
  assert_no_match Regexp.new(string), Page.first.all_html
end

Then('my page named {string} should have {int} parts') do |string, int|
  assert_equal int, Page.find_by_title(string).parts.size
end

Then("last read should be today") do
  Rails.logger.debug "comparing #{Page.first.last_read.to_date} with #{Date.current}"
  assert_equal Date.current, Page.first.last_read.to_date
end

Then("the part titles should be stored as {string}") do |title_string|
   assert_equal title_string, Page.first.parts.map(&:title).join(" & ")
end

Then('the read after date should be {int} year(s) from now') do |int|
  diff = Page.first.read_after.year - Date.today.year
  Rails.logger.debug "comparing #{Page.first.read_after.year} with #{Date.today.year} (#{diff})"
  assert_equal int, diff
end

Then('the read after date should be 6 months from now') do
  diff = Page.first.read_after.month - Date.today.month
  Rails.logger.debug "comparing #{Page.first.read_after.year} with #{Date.today.year} (#{diff})"
  assert_equal 6, diff.abs
end

Then('the read after date should be {string}') do |string|
  Rails.logger.debug "comparing #{Page.first.read_after} with #{string}"
  assert_equal string, Page.first.read_after.to_date.to_s
end

Then('the read after date for {string} should be {string}') do |title, date|
  page = Page.find_by_title(title)
  Rails.logger.debug "comparing #{page.read_after.to_date} with #{date}"
  assert_equal date, page.read_after.to_date.to_s
end

Then('the read after date for {string} should be today') do |title|
  page = Page.find_by_title(title)
  Rails.logger.debug "comparing #{page.read_after.to_date} with #{Date.current}"
  assert_equal Date.current, page.read_after.to_date
end

Then('my page named {string} should have url: {string}') do |title, url|
  page = Page.find_by_title(title)
  Rails.logger.debug "comparing #{page.url} with #{url}"
  assert_equal url, page.url
end

Then('the notes should NOT include {string}') do |string|
  assert_no_match Regexp.new(string), Page.first.notes
end

Then('the notes should include {string}') do |string|
  assert_match Regexp.new(string), Page.first.notes
end

Then('the notes should be empty') do
  assert Page.first.notes.blank?
end

Then('the end notes should be empty') do
  assert Page.first.end_notes.blank?
end

Then('the end notes should start with {string}') do |string|
  assert_match Regexp.new("^#{string}"), Page.first.end_notes
end

Then('the end notes should end with {string}') do |string|
  assert_match Regexp.new("#{string}$"), Page.first.end_notes
end

Then('the contents should start with {string}') do |string|
  assert_match Regexp.new("^<p>#{string}"), Page.first.scrubbed_html
end

Then('the contents should end with {string}') do |string|
  assert_match Regexp.new("#{string}</p>$"), Page.first.scrubbed_html
end

Then('{string} should be {string} soon') do |string, string2|
  page = Page.find_by_title(string)
  Rails.logger.debug "comparing #{page.soon} with #{string2}"
  assert_equal string2, page.soon_label
end
