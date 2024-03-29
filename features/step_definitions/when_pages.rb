# When page actions: edit the notes/title/url

When("I edit its tags") do
  within(".meta") { click_link("Tags") }
end

When("I change its raw html to") do |multi_line|
  html = multi_line.inspect.strip_quotes
  step "I change its raw html to \"#{html}\""
end

When("I change its raw html to {string}") do |html|
   page = Page.with_content.first
   raise "no pages that can edit raw html" unless page
   visit page_path(page)
   click_link "Edit Raw HTML"
   fill_in "pasted", with: html
   Rails.logger.debug "changing raw html to: #{html}"
   click_button "Update Raw HTML"
end

When("I change the raw html for {string} to {string}") do |title, html|
   page = Page.find_by title: title
   raise "no pages" unless page
   visit page_path(page)
   click_link "Edit Raw HTML"
   fill_in "pasted", with: html
   click_button "Update Raw HTML"
end

When("I view the text for reading aloud") do
   page = Page.with_content.first
   raise "no pages that can be read aloud" unless page
   visit page_path(page)
   within(".views") {click_link("Read")}
end

When("I download its epub") do
   page = Page.first
   raise "no pages" unless page
   visit page_path(page)
   within(".views") {click_link("ePub")}
end

When("I download the epub for {string}") do |title|
   page = Page.find_by title: title
   raise "no page with title #{title}" unless page
   visit page_path(page)
   within(".views") {click_link("ePub")}
end

When("I read it online") do
   page = Page.first
   raise "no pages" unless page
   visit page_path(page)
   within(".views") {click_link("HTML")}
end

When("I read {string} online") do |title|
   page = Page.find_by title: title
   raise "no page with title #{title}" unless page
   visit page_path(page)
   within(".views") {click_link("HTML")}
end

When("I add a parent with title {string}") do |title|
  click_link("Add Parent")
  fill_in("add_parent", :with => title)
  click_button("Add")
end

When("I change the title to {string}") do |title|
  within(".meta") { click_link("Title")}
  fill_in("title", :with => title)
  click_button("Update")
end

When("I refetch the following") do |value|
  within(".content") { click_link("Refetch")}
  fill_in("url_list", :with => value)
  click_button("Refetch")
end

When('I edit the raw html with {string}') do |string|
  click_link("Edit Raw HTML")
  html = File.open(Rails.root + "tmp/html/#{string}.html", 'r:utf-8') { |f| f.read }
  fill_in("pasted", :with => html)
  click_button("Update Raw HTML")
end

When('I follow the link for {string}') do |string|
  page = Page.find_by title: string
  click_link("/pages/#{page.id}")
end

When('I rate it {int} stars') do |int|
   page = Page.first
   raise "no page with title #{title}" unless page
   visit page_path(page)
   click_link("Rate")
   choose(int.to_s)
   click_button("Rate")
end

