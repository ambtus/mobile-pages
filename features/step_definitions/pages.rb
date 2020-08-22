Given("I have no pages") do
  Page.delete_all
end

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

# create many identical pages
Given("{int} pages exist") do |count|
  count.times do |i|
    Page.create(title: "Page #{(i+1)}")
    Kernel::sleep 1
  end
end

# create a page
Given /a page exists(?: with (.*))?/ do |fields|
  fields.blank? ? hash = {} : hash = fields.create_hash
  hash[:title] = hash[:title] || "Page 1"
  hash[:urls] =  hash[:urls].split(',').join("\r") if hash[:urls]
  Page.create_from_hash(hash)
end

# create one or more different pages
Given /^the following pages?$/ do |table|
  Page.delete_all
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    hash['urls'] =  hash['urls'].split(',').join("\r") if hash['urls']
    Page.create_from_hash(hash.symbolize_keys)
  end
end

Given("pages with all possible ratings exist") do
  Page.delete_all
  interesting = Rating.find_or_create_by(name: "interesting")
  boring = Omitted.find_or_create_by(name: "boring")
  loving = Rating.find_or_create_by(name: "loving")
  hateful = Omitted.find_or_create_by(name: "hateful")
  p = Page.create(title: "page1")
  p.rate(1)
  p.tags << [hateful, boring]
  p = Page.create(title: "page2h")
  p.rate(2)
  p.tags << hateful
  p = Page.create(title: "page2b")
  p.rate(2)
  p.tags << boring
  p = Page.create(title: "page3")
  p.rate(3)
  p = Page.create(title: "page3l")
  p.rate(3)
  p.tags << [boring,loving]
  p = Page.create(title: "page3h")
  p.rate(3)
  p.tags << [hateful,interesting]
  p = Page.create(title: "page4l")
  p.rate(4)
  p.tags << loving
  p = Page.create(title: "page4i")
  p.rate(4)
  p.tags << interesting
  p = Page.create(title: "page5")
  p.rate(5)
  p.tags << [interesting, loving]
  Page.all.map(&:cache_tags)
end

And /^the pages?$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each { |h| Page.create(h) }
end

Then /^my page named "([^\"]*)" should contain "([^\"]*)"$/ do |title, string|
  assert_match Regexp.new(string), Page.find_by_title(title).edited_html
end
Then /^my page named "([^\"]*)" should NOT contain "([^\"]*)"$/ do |title, string|
  assert_no_match Regexp.new(string), Page.find_by_title(title).edited_html
end

Then("last read should be today") do
  Rails.logger.debug "DEBUG: comparing #{Page.first.last_read.to_date} with #{Date.current}"
  assert Page.first.last_read.to_date == Date.current
end

Then('I should see today within {string}') do |string|
  within(string) { assert assert_text(Date.current.to_s) }
end

Then('I should NOT see today within {string}') do |string|
  within(string) { assert assert_no_text(Date.current.to_s)}
end


Then("the part titles should be stored as {string}") do |title_string|
   assert Page.first.parts.map(&:title).join(" & ") == title_string
end

Then('the read after date should be {int} years from now') do |int|
  diff = Page.first.read_after.year - Date.today.year
  Rails.logger.debug "DEBUG: comparing #{Page.first.read_after.year} with #{Date.today.year} (#{diff})"
  assert diff == int
end
