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

Then("the download epub command should include tags: {string}") do |string|
  assert Page.first.epub_command.match("--tags \"[^\"]*#{string}[^\"]*\"")
end

Then("the download epub command should not include tags: {string}") do |string|
  assert !Page.first.epub_command.match("--tags \"[^\"]*#{string}[^\"]*\"")
end

Then("the download epub command should include authors: {string}") do |string|
  assert Page.first.epub_command.match("--authors \"[^\"]*#{string}[^\"]*\"")
end

Then("the download epub command should include series: {string}") do |string|
  assert Page.first.epub_command.match("--series \"[^\"]*#{string}[^\"]*\"")
end

Then("the download epub command should not include authors: {string}") do |string|
  assert !Page.first.epub_command.match("--authors \"[^\"]*#{string}[^\"]*\"")
end

Then("the download epub command should include comments: {string}") do |string|
  assert Page.first.epub_command.match("--comments \"[^\"]*#{string}[^\"]*\"")
end

Then("the download epub command should not include comments: {string}") do |string|
  assert !Page.first.epub_command.match("--comments \"[^\"]*#{string}[^\"]*\"")
end

