Given("I have no pages") do
  Page.delete_all
end

Then('I should have {int} page') do |int|
  Page.count == int
end
Then('I should have {int} pages') do |int|
  Page.count == int
end

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

# create many identical pages
Given("{int} pages exist") do |count|
  count.times do |i|
    Page.create(title: "Page #{(i+1)}", last_read: "2000-01-#{i+1}")
  end
end

Given /^part6 exists$/ do
  page = Page.new
  page.title = "Part 6"
  page.save
  page.url =  "https://www.fanfiction.net/s/5409165/6/It-s-For-a-Good-Cause-I-Swear"
  page.save
  page.raw_html = File.open(Rails.root + "features/html/part6.html", 'r:utf-8') { |f| f.read }
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
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    hash['urls'] =  hash['urls'].split(',').join("\r") if hash['urls']
    Page.create_from_hash(hash.symbolize_keys)
  end
end

Given("pages with all possible stars exist") do
  Page.create(title: "page0")
  Page.create(title: "page1").rate(1).read_today.update_read_after
  Page.create(title: "page2h").rate(2).read_today.update_read_after
  Page.create(title: "page3").rate(3).read_today.update_read_after
  Page.create(title: "page4l").rate(4).read_today.update_read_after
  Page.create(title: "page5").rate(5).read_today.update_read_after
  Page.create(title: "page9").make_unfinished
end

Given("pages with ratings and omitteds exist") do
  Page.delete_all
  interesting = Rating.find_or_create_by(name: "interesting")
  boring = Omitted.find_or_create_by(name: "boring")
  loving = Rating.find_or_create_by(name: "loving")
  hateful = Omitted.find_or_create_by(name: "hateful")
  Page.find_or_create_by(title: "page1").tags << [hateful, boring]
  Page.find_or_create_by(title: "page2h").tags << hateful
  Page.find_or_create_by(title: "page2b").tags << boring
  Page.find_or_create_by(title: "page3")
  Page.find_or_create_by(title: "page3l").tags << [boring,loving]
  Page.find_or_create_by(title: "page3h").tags << [hateful,interesting]
  Page.find_or_create_by(title: "page4l").tags << loving
  Page.find_or_create_by(title: "page4i").tags << interesting
  Page.find_or_create_by(title: "page5").tags << [interesting, loving]
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

Then('my page named {string} should have {int} parts') do |string, int|
  assert Page.find_by_title(string).parts.size == int
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
