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
    con.pages.map(&:update_tag_cache!)
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
  page.notes = File.open(Rails.root + "tmp/html/silent.html", 'r:utf-8') { |f| f.read }
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

Given('I have a partially read series') do
  series = Series.create!(title: "Grandparent")
  parent1 = Single.create!(title: "Parent1", parent_id: series.id, position: 1).rate_today(4)
  parent2 = Book.create!(title: "Parent2", parent_id: series.id, position: 2)
  Chapter.create!(title: "Subpart1", parent_id: parent2.id, position: 1)
  Chapter.create!(title: "Subpart2", parent_id: parent2.id, position: 2).rate_today(3)
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
  book2 = Book.create!(title: "Another Book", parent_id: series.id, position: 2)
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

Given('the second had been made read first') do
  page = Page.second
  page.update read_after: page.read_after - 1.year
end

Given('an editable page exists') do
  page = Page.create!(url: "file:///#{Rails.root}/tmp/html/edit.html", title: "Page 1")
end

Given("a read page exists") do
  Single.create(title: "Page 1",).rate_today(5)
end

Given("a partially read page exists") do
  book3 = Book.create(title: "Book")
  Chapter.create(title: "Read", parent_id: book3.id, position: 1).rate_today(5)
  Chapter.create(title: "Unread", parent_id: book3.id, position: 2)
  book3.update_from_parts
end

Given("six downloaded and six hidden soon pages exist") do
  6.times do |i|
    Single.create(title: "reading #{i+1}", soon: 0)
  end
  6.times do |i|
    Single.create(title: "hidden #{i+1}", soon: 0, hidden: true)
  end
end

Given("eleven downloaded pages exist") do
  11.times do |i|
    Single.create(title: "reading #{i+1}", soon: 0)
  end
end

Given('a book exists') do
  book = Book.create!(title: "Book")
  6.times do |i|
    Chapter.create(title: "chapter #{i+1}", parent_id: book.id, position: i+1)
  end
  book.update_from_parts
end

Given('a partially read book exists') do
  book = Book.create!(title: "Book")
  6.times do |i|
    Chapter.create(title: "chapter #{i+1}", parent_id: book.id, position: i+1)
  end
  chapter1=book.parts.first
  chapter1.update last_read: "2009-01-01", stars: 4
  chapter1.update_read_after
  chapter2=book.parts.second
  chapter2.update last_read: "2010-01-01", stars: 2
  chapter2.update_read_after
  book.update_from_parts
end

Given('a work exists with chapter end_notes') do
  book = Book.create(title: "Book")
  Chapter.create(title: "ch1", parent_id: book.id, position: 1, end_notes: "chapter 1 end notes", url: "http://test.sidrasue.com/test1.html")
  Chapter.create(title: "ch2", parent_id: book.id, position: 2, end_notes: "chapter 2 end notes", url: "http://test.sidrasue.com/test2.html")
  book.update_from_parts
end

Given('a work exists with chapter end_notes at end') do
  book = Book.create(title: "Book")
  Chapter.create(title: "ch1", parent_id: book.id, position: 1, end_notes: "chapter 1 end notes", url: "http://test.sidrasue.com/test1.html", at_end: true)
  Chapter.create(title: "ch2", parent_id: book.id, position: 2, end_notes: "chapter 2 end notes", url: "http://test.sidrasue.com/test2.html", at_end: true)
  book.update_from_parts
end

Given('a work exists with toggled chapter end_notes') do
  book = Book.create(title: "Book")
  Chapter.create(title: "ch1", parent_id: book.id, position: 1, end_notes: "chapter 1 end notes", url: "http://test.sidrasue.com/test1.html")
  Chapter.create(title: "ch2", parent_id: book.id, position: 2, url: "http://test.sidrasue.com/test2.html")
  Chapter.create(title: "ch3", parent_id: book.id, position: 3, end_notes: "chapter 3 end notes", url: "http://test.sidrasue.com/test3.html")
  book.parts.update_all(at_end: true)
end

Given('a long partially read page exists') do
  book = Book.create(title: 'Book')
  10.times {|i| Chapter.create(title: "Part #{i+1}", parent_id: book.id, position: i+1, url: "https://www.fanfiction.net/s/7347955/#{i+1}/Dreaming-of-Sunshine", last_read: "2009-01-01", stars: 4)}
  10.times {|i| Chapter.create(title: "Part #{i+11}", parent_id: book.id, position: i+11, url: "https://www.fanfiction.net/s/7347955/#{i+11}/Dreaming-of-Sunshine")}
  book.update_from_parts
end

Given('a book with a tagged chapter exists') do
  book = Book.create!(title: "Book")
  pro = Pro.find_or_create_by(name: "interesting")
  chapter = Chapter.create(title: "chapter 1", parent_id: book.id, position: 1)
  chapter.tags << pro
  chapter.update_tag_cache!
  book.update_from_parts
end

Given('a work exists with chapter and work notes') do
  book = Book.create(title: "Book", notes: "work notes")
  Chapter.create(title: "ch1", parent_id: book.id, position: 1, notes: "ch1 notes", url: "http://test.sidrasue.com/test1.html")
  Chapter.create(title: "ch2", parent_id: book.id, position: 2, notes: "ch2 notes", url: "http://test.sidrasue.com/test2.html")
  book.update_from_parts
end

Given('the single has a parent') do
  page = Single.first
  parent = Series.create(title: "Parent")
  page.add_parent("Parent")
end
