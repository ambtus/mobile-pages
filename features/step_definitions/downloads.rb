Then("the download directory should exist") do
  assert File.exists?(Page.first.download_dir)
end

Then("the download directory should not exist") do
  assert !File.exists?(Page.first.download_dir)
end

Then("the download html file should exist") do
  assert File.exists?("#{Page.first.download_basename}.html")
end

Then("the download epub file should exist") do
  assert File.exists?("#{Page.first.download_basename}.epub")
end

Then("the download epub file should not exist") do
  assert !File.exists?("#{Page.first.download_basename}.epub")
end

Then /^the download epub command should include (.+): "([^"]*)"$/ do |option, text|
  assert Page.first.epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

Then /^the download epub command should not include (.+): "([^"]*)"$/ do |option, text|
  assert !Page.first.epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

Then /^the download epub command for "([^"]*)" should include (.+): "([^"]*)"$/ do |title, option, text|
  assert Page.find_by_title(title).epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

Then /^the download epub command for "([^"]*)" should not include (.+): "([^"]*)"$/ do |title, option, text|
  assert !Page.find_by_title(title).epub_command.match("--#{option} \"[^\"]*#{text}[^\"]*\"")
end

