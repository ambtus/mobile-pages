Given("I have no pages") do
  Page.delete_all
end

Then('I should have {int} page(s)') do |int|
  Rails.logger.debug "DEBUG: currently have #{Page.count} pages"
  assert Page.count == int
end

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

# create many identical pages
Given("{int} pages exist") do |count|
  count.times do |i|
    Page.create(title: "Page #{(i+1)}", read_after: "2000-01-#{i+1}")
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

Given("pages with all possible unreads exist") do
  Single.create(title: "not read single")
  Single.create(title: "yes read single",).rate(5).read_today.update_read_after

  book1 = Book.create(title: "not read book")
  Chapter.create(title: "not read chapter", parent_id: book1.id)
  book1.cleanup.update_read_after

  book2 = Book.create(title: "yes read book")
  Chapter.create(title: "yes read chapter", parent_id: book2.id).rate(5).read_today.update_read_after
  book2.cleanup.update_read_after

  book3 = Book.create(title: "partially read book")
  Chapter.create(title: "not read chapter", parent_id: book3.id)
  Chapter.create(title: "yes read chapter", parent_id: book3.id).rate(5).read_today.update_read_after
  book3.cleanup.update_read_after

  series1 = Series.create(title: "not read series")
  book4 = Book.create(title: "another not read book", parent_id: series1.id)
  Chapter.create(title: "another not read chapter", parent_id: book4.id)
  book4.cleanup.update_read_after
  series1.cleanup.update_read_after

  series2 = Series.create(title: "partially read series")
  book5 = Book.create(title: "another partially read book", parent_id: series2.id)
  Chapter.create(title: "yet another not read chapter", parent_id: book5.id)
  Chapter.create(title: "another read chapter", parent_id: book5.id).rate(5).read_today.update_read_after
  book5.cleanup.update_read_after
  series2.cleanup.update_read_after

  series3 = Series.create(title: "yes read series")
  book6 = Book.create(title: "another read book", parent_id: series3.id)
  Chapter.create(title: "another read chapter", parent_id: book6.id).rate(5).read_today.update_read_after
  book6.cleanup.update_read_after
  series3.cleanup.update_read_after
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

Then('my page named {string} should have url: {string}') do |title, url|
  page = Page.find_by_title(title)
  Rails.logger.debug "DEBUG: comparing #{page.url} with #{url}"
  assert page.url == url
end
