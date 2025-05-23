Then("the download directory should exist") do
  assert File.exist?(Page.first.download_dir)
end

Then("the download directory should NOT exist") do
  assert !File.exist?(Page.first.download_dir)
end

Then("the download html file should exist") do
  assert File.exist?("#{Page.first.download_basename}.html")
end

Then("the download html file should NOT exist") do
  assert !File.exist?("#{Page.first.download_basename}.html")
end

Then("the download epub file should exist") do
  assert File.exist?("#{Page.first.download_basename}.epub")
end

Then("the download epub file should NOT exist") do
  assert !File.exist?("#{Page.first.download_basename}.epub")
end
