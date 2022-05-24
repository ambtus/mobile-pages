Then('the epub html contents for {string} should contain {string}') do |title, string|
  zipfile_name = "#{Page.find_by_title(title).download_basename}.epub"
  Rails.logger.debug "epub filename: #{zipfile_name}"
  html = Zip::File.open(zipfile_name) do |zip_file|
    html_files = zip_file.glob('*.html')
    html_files.map(&:get_input_stream).map(&:read).join
  end
  assert html.match(string)
end

Then('the epub html contents for {string} should NOT contain {string}') do |title, string|
  zipfile_name = "#{Page.find_by_title(title).download_basename}.epub"
  Rails.logger.debug "epub filename: #{zipfile_name}"
  html = Zip::File.open(zipfile_name) do |zip_file|
    html_files = zip_file.glob('*.html')
    html_files.map(&:get_input_stream).map(&:read).join
  end
  assert_no_match string, html
end

## FIXME? now that I can inspect the actual epub,
## should I check that instead of the command to create it?

Then /^the download epub command should include (.+): "([^"]*)"$/ do |option, text|
  assert Page.first.epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

Then /^the download epub command should NOT include (.+): "([^"]*)"$/ do |option, text|
  assert !Page.first.epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

Then /^the download epub command for "([^"]*)" should include (.+): "([^"]*)"$/ do |title, option, text|
  Rails.logger.debug "page with title #{title} should have epub with #{option} #{text}"
  epub_tags = Page.find_by_title(title).epub_tags
  Rails.logger.debug "epub_tags is #{epub_tags}"
  match_data = epub_tags.match("--#{option} ([^-]*)")
  Rails.logger.debug "match #{text} in #{match_data[1]}"
  assert match_data[1].match(text)
end

Then /^the download epub command for "([^"]*)" should NOT include (.+): "([^"]*)"$/ do |title, option, text|
  Rails.logger.debug "page with title #{title} should not have epub with #{option} #{text}"
  epub_tags = Page.find_by_title(title).epub_tags
  Rails.logger.debug "epub_tags is #{epub_tags}"
  match_data = epub_tags.match("--#{option} ([^-]*)")
  if match_data
    Rails.logger.debug "do not match #{text} in #{match_data[1]}"
    assert !match_data[1].match(text)
  else
    assert true
  end
end

Then('the download epub title for {string} should be {string}') do |string, string2|
  epub_title = Page.find_by_title(string).epub_title
  Rails.logger.debug "epub_title is #{epub_title} (want #{string2})"
  assert epub_title == string2
end
