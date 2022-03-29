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

Then('the epub html contents for {string} should contain {string}') do |title, string|
  zipfile_name = "#{Page.find_by_title(title).download_basename}.epub"
  Rails.logger.debug "DEBUG: epub filename: #{zipfile_name}"
  html = Zip::File.open(zipfile_name) do |zip_file|
    html_files = zip_file.glob('*.html')
    html_files.map(&:get_input_stream).map(&:read).join
  end
  assert html.match(string)
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

