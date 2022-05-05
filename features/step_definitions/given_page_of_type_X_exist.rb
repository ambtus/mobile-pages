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

Given("pages with all possible types exist") do
  Single.create(title: "One-shot", url: "http://test.sidrasue.com/short.html")
  Book.create(title: "Novel", base_url: "http://test.sidrasue.com/long*.html", url_substitutions: "1-2")

  series = Series.create!(title: "Trilogy")
  book1 = Book.create!(title: "Alpha", parent_id: series.id, position: 1)
  book2 = Book.create!(title: "Beta", parent_id: series.id, position: 2)
  child1 = Chapter.create!(title: "Prologue", parent_id: book1.id, position: 1, url: "http://test.sidrasue.com/parts/1.html")
  child2 = Chapter.create!(title: "Epilogue", parent_id: book2.id, position: 1, url: "http://test.sidrasue.com/parts/5.html")

  collection = Collection.create!(title: "Life's Work")

  Single.create(title: "First", url: "http://test.sidrasue.com/test.html", parent_id: collection.id, position: 1)
  Book.create(title: "Second", base_url: "http://test.sidrasue.com/medium*.html", url_substitutions: "1-2", parent_id: collection.id, position: 2)
  series2 = Series.create(title: "Third", parent_id: collection.id, position: 3)
  Book.create(title: "Fourth", parent_id: series2.id, position: 1)
  Book.create(title: "Fifth", parent_id: series2.id, position: 2)
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
