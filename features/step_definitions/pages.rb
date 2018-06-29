Given /^I have no pages$/ do
  Page.delete_all
end

Given /^the following pages?$/ do |table|
  Page.delete_all
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    if hash['urls']
      newhash = hash.dup
      newhash['urls'] =  newhash['urls'].split('\\n').join("\r")
      Page.create(newhash)
    else
      Page.create(hash)
    end
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
  assert Page.first.last_read.to_date == Date.today
end
