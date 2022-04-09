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

Given /^counting exists$/ do
  page = Single.new
  page.title = "Counting"
  page.save
  page.url =  "https://www.fanfiction.net/s/5853866/1/Counting"
  page.save
  page.raw_html = File.open(Rails.root + "features/html/counting.html", 'r:utf-8') { |f| f.read }
end

Given("pages with all possible types exist") do

  Single.create(title: "One-shot", url: "http://test.sidrasue.com/short.html")
  Book.create(title: "Novel", base_url: "http://test.sidrasue.com/long*.html", url_substitutions: "1-2")

  series = Series.create!(title: "Trilogy")
  book1 = Book.create!(title: "Alpha", parent_id: series.id, position: 1)
  book2 = Book.create!(title: "Beta", parent_id: series.id, position: 1)
  child1 = Chapter.create!(title: "Prologue", parent_id: book1.id, position: 1, url: "http://test.sidrasue.com/parts/1.html")
  child2 = Chapter.create!(title: "Epilogue", parent_id: book2.id, position: 1, url: "http://test.sidrasue.com/parts/5.html")

  collection = Collection.create!(title: "Life's Work")

  Single.create(title: "First", url: "http://test.sidrasue.com/test.html", parent_id: collection.id, position: 1)
  Book.create(title: "Second", base_url: "http://test.sidrasue.com/medium*.html", url_substitutions: "1-2", parent_id: collection.id, position: 2)
  series2 = Series.create(title: "Third", parent_id: collection.id, position: 3)
  Book.create(title: "Fourth", parent_id: series2.id, position: 1)
  Book.create(title: "Fifth", parent_id: series2.id, position: 2)


end


Given('Uneven exists') do
  parent = Book.create!(title: "Uneven")
  4.times do |i|
    int = i + 1
    part = Chapter.create(title: "part #{int}", parent_id: parent.id, position: int, last_read: "2010-01-0#{int}", stars: int).update_read_after
  end
  parent.update_last_read.update_stars.update_read_after
  last = Chapter.create(title: "part 5")
  last.add_parent("Uneven")
end
