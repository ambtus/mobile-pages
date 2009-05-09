Given /^I have no pages$/ do
  Page.delete_all
end

Given /^the following pages?$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each {|hash| Page.create(hash)}
end

# can't use "should see" because the mobile file is downloaded, not displayed
Then /^My document should contain "([^\"]*)"$/ do |string|
  string = string.gsub("\\n", "\n")
  assert_match string, File.open(Page.first.mobile_file) {|f| f.read}
end
Then /^My document should not contain "([^\"]*)"$/ do |string|
  assert_no_match Regexp.new(string), File.open(Page.first.mobile_file) {|f| f.read}
end
