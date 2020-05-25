Then("the download epub command should include tags: {string}") do |string|
  assert Page.first.epub_command.match("--tags \"[^\"]*#{string}[^\"]*\"")
end

Then("the download epub command should not include tags: {string}") do |string|
  assert !Page.first.epub_command.match("--tags \"[^\"]*#{string}[^\"]*\"")
end

Then("the download epub command should include authors: {string}") do |string|
  assert Page.first.epub_command.match("--authors \"[^\"]*#{string}[^\"]*\"")
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

