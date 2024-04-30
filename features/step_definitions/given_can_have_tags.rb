Given('a Single exists') do
  Single.create!(title: "Single")
end

Given('a Book exists') do
  book = Book.create!(title: "Book")
  2.times do |i|
    Chapter.create(title: "Chapter #{i+1}", parent_id: book.id, position: i+1)
  end
end

Then('I can tag {string} with fandom and author') do |string|
  fandom = Fandom.find_or_create_by(name: "Harry Potter")
  author = Author.find_or_create_by(name: "Sidra")
  page = Page.find_by_title(string)
  visit page_path(page)
  within(".meta") { click_link("Tags") }
  select("Harry Potter")
  select("Sidra")
  click_button("Update Tags")
end

Then('the download tag string for {string} should include fandom and author') do |string|
  page = Page.find_by_title(string)
  assert_match "Harry Potter", page.download_tag_string
  assert_match "Sidra", page.download_tag_string
end

Then('I can NOT tag {string} with fandom and author') do |string|
  fandom = Fandom.find_or_create_by(name: "Harry Potter")
  author = Author.find_or_create_by(name: "Sidra")
  page = Page.find_by_title(string)
  visit page_path(page)
  within(".meta") { click_link("Tags") }
  within(".form") {assert_no_text("Author:")}
  within(".form") {assert_no_text("Sidra") }
  within(".form") {assert_no_text("Fandom:")}
  within(".form") {assert_no_text("Harry Potter")}
end

Then('the index tags for {string} should include fandom and author') do |string|
  visit filter_path
  fill_in("page_title", :with => string)
  click_button("Find")
  # save_and_open_page
  assert_text("Sidra")
  assert_text("Harry Potter")
end

Then('the show tags for {string} should include fandom and author') do |string|
  page = Page.find_by_title(string)
  visit page_path(page)
  assert_text("Sidra")
  assert_text("Harry Potter")
end

Then('the tags for {string} should NOT include fandom and author') do |string|
  page = Page.find_by_title(string)
  Rails.logger.debug "#{page.tags.map(&:base_name)} should be blank"
  assert page.tags.empty?
end

Then('the tags for {string} should include fandom and author') do |string|
  page = Page.find_by_title(string)
  fandom = Fandom.find_or_create_by(name: "Harry Potter")
  author = Author.find_or_create_by(name: "Sidra")
  assert page.tags.fandoms.include?(fandom)
  assert page.tags.authors.include?(author)
end

Given('tags exist') do
  fandom = Fandom.find_or_create_by(name: "Harry Potter")
  author = Author.find_or_create_by(name: "Sidra")
end

Given /^Counting Drabbles had tags$/ do
  page = Series.find_by(title: "Counting Drabbles")
  fandom = Fandom.find_or_create_by(name: "Harry Potter")
  author = Author.find_or_create_by(name: "Sidra")
  page.tags << [fandom, author]
end

