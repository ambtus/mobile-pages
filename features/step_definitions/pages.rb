Given /^I have no pages$/ do
  Page.delete_all
end

# create a page
Given /a page exists(?: with (.*))?/ do |fields|
  fields.blank? ? hash = {} : hash = fields.create_hash
  hash[:title] = hash[:title] || "Page 1"
  hash[:urls] =  hash[:urls].split(',').join("\r") if hash[:urls]
  Page.create_from_hash(hash)
end

# create many identical pages
Given("{int} pages exist") do |count|
  count.times do |i|
    Page.create(title: "Page #{(i+1)}")
    Kernel::sleep 1
  end
end

# create many different pages
Given /^the following pages?$/ do |table|
  Page.delete_all
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    hash['urls'] =  hash['urls'].split('\\n').join("\r") if hash['urls']
    Page.create_from_hash(hash.symbolize_keys)
  end
end

Given /^pages with all possible ratings exist$/ do
  Page.delete_all
  3.times do |interesting|
    3.times do |nice|
      p = Page.create(:title => "page" + interesting.to_s + nice.to_s)
      p.update_rating(interesting.to_s, nice.to_s)
    end
  end
end

And /^the pages?$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each { |h| Page.create(h) }
end

Then /^my page named "([^\"]*)" should contain "([^\"]*)"$/ do |title, string|
  assert_match Regexp.new(string), Page.find_by_title(title).edited_html
end
Then /^my page named "([^\"]*)" should not contain "([^\"]*)"$/ do |title, string|
  assert_no_match Regexp.new(string), Page.find_by_title(title).edited_html
end

Then /^the download directory should exist for page titled "([^"]*)"$/ do |title|
  page = Page.find_by_title(title)
  assert File.exists?(page.download_dir)
end

Then /^the download directory should not exist for page titled "([^"]*)"$/ do |title|
  page = Page.find_by_title(title)
  assert !File.exists?(page.download_dir)
end

Then /^the download html file should exist for page titled "([^"]*)"$/ do |title|
  page = Page.find_by_title(title)
  assert File.exists?("#{page.download_basename}.html")
end

Then /^the download epub file should exist for page titled "([^"]*)"$/ do |title|
  page = Page.find_by_title(title)
  assert File.exists?("#{page.download_basename}.epub")
end

Then /^the download epub file should not exist for page titled "([^"]*)"$/ do |title|
  page = Page.find_by_title(title)
  assert !File.exists?("#{page.download_basename}.epub")
end

Then(/^last read should be today$/) do
  Rails.logger.debug "DEBUG: comparing #{Page.first.last_read.to_date} with #{Date.current}"
  assert Page.first.last_read.to_date == Date.current
end


