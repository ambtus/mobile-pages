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

# can't use "should see" because the mobile file is downloaded, not displayed
Then /^my document should contain "([^\"]*)"$/ do |string|
  string = string.gsub("\\n", "\n")
  assert_match string, File.open(Page.first.mobile_file) {|f| f.read}
end
Then /^my document should not contain "([^\"]*)"$/ do |string|
  assert_no_match Regexp.new(string), File.open(Page.first.mobile_file) {|f| f.read}
end
Then /^my document named "([^\"]*)" should contain "([^\"]*)"$/ do |title, string|
  string = string.gsub("\\n", "\n")
  assert_match string, File.open(Page.find_by_title(title).mobile_file) {|f| f.read}
end
Then /^my document named "([^\"]*)" should not contain "([^\"]*)"$/ do |title, string|
  assert_no_match Regexp.new(string), File.open(Page.find_by_title(title).mobile_file) {|f| f.read}
end
