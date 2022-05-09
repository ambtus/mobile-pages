Given /a page exists(?: with (.*))?/ do |fields|
  fields.blank? ? hash = {} : hash = fields.create_hash
  hash[:title] = hash[:title] || "Page 1"
  hash[:urls] =  hash[:urls].split(',').join("\r") if hash[:urls]
  Utilities.create_from_hash(hash)
end

# create one or more different pages
Given /^the following pages?$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    hash['urls'] =  hash['urls'].split(',').join("\r") if hash['urls']
    Utilities.create_from_hash(hash.symbolize_keys)
  end
end

Given("{int} pages exist") do |count|
  count.times do |i|
    Page.create(title: "Page #{(i+1)}", read_after: "2000-01-#{i+1}")
    Kernel::sleep 1 if i<1  # sorting on created by for 2 page
  end
end

Given('{int} pages with cons: {string} exist') do |count, string|
  con = Con.find_or_create_by(name: string)
  count.times do |i|
    con.pages << Page.create(title: "Page #{(i+1)}", read_after: "2000-01-#{i+1}")
  end
end

Given('Uneven exists') do
  parent = Book.create!(title: "Uneven")
  4.times do |i|
    int = i + 1
    part = Chapter.create(title: "part #{int}", parent_id: parent.id, position: int, last_read: "2010-01-0#{int}", stars: int).update_read_after
  end
  Chapter.create(title: "part 5", parent_id: parent.id, position: 5)
  parent.update_from_parts
end

Given('link in notes exists') do
  page = Single.create!(title: "Silent Sobs")
  page.notes = File.open(Rails.root + "features/html/silent.html", 'r:utf-8') { |f| f.read }
  page.save!
end

Given('a page with very long notes exists') do
  string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*10
  Page.create(title: "Page 1", notes: string)
end

Given('system down exists') do
  page = Page.create!(url: "http://test.sidrasue.com/test.html", title: "Test")
  page.raw_html = "system down"
end

Given('I have a series with read_after {string}') do |string|
  series = Series.create!(title: "Grandparent", read_after: string, last_read: string.to_date - 1.year, stars: 4)
  parent1 = Single.create!(title: "Parent1", parent_id: series.id, position: 1, read_after: string, last_read: string.to_date - 1.year, stars: 4)
  parent2 = Book.create!(title: "Parent2", parent_id: series.id, position: 2, read_after: string, last_read: string.to_date - 1.year, stars: 4)
  child = Chapter.create!(title: "Subpart", parent_id: parent2.id, position: 1, read_after: string, last_read: string.to_date - 1.year, stars: 4)
end

Given('I have a book with read_after {string}') do |string|
  parent = Single.create!(title: "Parent", read_after: string, last_read: string.to_date - 1.year, stars: 4)
  child = Chapter.create!(title: "Part 1", parent_id: parent.id, position: 1, read_after: string, last_read: string.to_date - 1.year, stars: 4)
end

Given('I have a single with read_after {string}') do |string|
  Single.create!(title: "Single", read_after: string, last_read: string.to_date - 1.year, stars: 4)
end

Given('a series exists') do
  series = Series.create!(title: "Series")
  book1 = Book.create!(title: "Book1", parent_id: series.id, position: 1)
    Chapter.create!(title: "Prologue", parent_id: book1.id,  position: 1, url: "http://test.sidrasue.com/parts/1.html")
 Chapter.create!(title: "Cliffhanger", parent_id: book1.id,  position: 2, url: "http://test.sidrasue.com/parts/2.html")
  book2 = Book.create!(title: "Book2", parent_id: series.id, position: 2)
     Chapter.create!(title: "Season2", parent_id: book2.id,  position: 1, url: "http://test.sidrasue.com/parts/3.html")
    Chapter.create!(title: "Epilogue", parent_id: book2.id,  position: 2, url: "http://test.sidrasue.com/parts/4.html")
       Single.create!(title: "Extras", parent_id: series.id, position: 3, url: "http://test.sidrasue.com/parts/5.html")
end

Given('I have Books with titles {string} and {string}') do |title1, title2|
  Book.create(title: title1, base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1-2")
  Book.create(title: title2, base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "4-6")
end

Given('I have a Single with title {string} and url {string}') do |title, url|
  Single.create(title: title, url: url)
end

Given('three singles exist') do
  3.times do |i|
    Single.create(title: "Parent#{i+1}")
  end
end