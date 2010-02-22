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

And /^the pages?$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each { |h| Page.create(h) }
end

Then /^my page named "([^\"]*)" should contain "([^\"]*)"$/ do |title, string|
  assert_match Regexp.new(string), Page.find_by_title(title).clean_html
end
Then /^my page named "([^\"]*)" should not contain "([^\"]*)"$/ do |title, string|
  assert_no_match Regexp.new(string), Page.find_by_title(title).clean_html
end
