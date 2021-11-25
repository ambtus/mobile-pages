Then("the download directory should exist") do
  assert File.exists?(Page.first.download_dir)
end

Then("the download directory should NOT exist") do
  assert !File.exists?(Page.first.download_dir)
end

Then("the download html file should exist") do
  assert File.exists?("#{Page.first.download_basename}.html")
end

Then("the download html file should NOT exist") do
  assert !File.exists?("#{Page.first.download_basename}.html")
end

Then("the download epub file should exist") do
  assert File.exists?("#{Page.first.download_basename}.epub")
end

Then("the download epub file should NOT exist") do
  assert !File.exists?("#{Page.first.download_basename}.epub")
end

Then /^the download epub command should include (.+): "([^"]*)"$/ do |option, text|
  assert Page.first.epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

Then /^the download epub command should NOT include (.+): "([^"]*)"$/ do |option, text|
  assert !Page.first.epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

Then /^the download epub command for "([^"]*)" should include (.+): "([^"]*)"$/ do |title, option, text|
  Rails.logger.debug "DEBUG: page with title #{title} should have epub with #{option} #{text}"
  epub_tags = Page.find_by_title(title).epub_tags
  Rails.logger.debug "DEBUG: epub_tags is #{epub_tags}"
  match_data = epub_tags.match("--#{option} ([^-]*)")
  Rails.logger.debug "DEBUG: match #{text} in #{match_data[1]}"
  assert match_data[1].match(text)
end

Then /^the download epub command for "([^"]*)" should NOT include (.+): "([^"]*)"$/ do |title, option, text|
  Rails.logger.debug "DEBUG: page with title #{title} should not have epub with #{option} #{text}"
  epub_tags = Page.find_by_title(title).epub_tags
  Rails.logger.debug "DEBUG: epub_tags is #{epub_tags}"
  match_data = epub_tags.match("--#{option} ([^-]*)")
  if match_data
    Rails.logger.debug "DEBUG: do not match #{text} in #{match_data[1]}"
    assert !match_data[1].match(text)
  else
    assert true
  end
end

