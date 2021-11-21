Given('I have a series with read_after {string}') do |string|
  series = Series.create!(title: "Grandparent", read_after: string)
  parent1 = Single.create!(title: "Parent1", parent_id: series.id, position: 1, read_after: string)
  parent2 = Book.create!(title: "Parent2", parent_id: series.id, position: 2, read_after: string)
  child = Chapter.create!(title: "Subpart", parent_id: parent2.id, position: 1, read_after: string)
end

Given /^counting exists$/ do
  page = Single.new
  page.title = "Counting"
  page.save
  page.url =  "https://www.fanfiction.net/s/5853866/1/Counting"
  page.save
  page.raw_html = File.open(Rails.root + "features/html/counting.html", 'r:utf-8') { |f| f.read }
end

Given('I have a Trilogy') do
  series = Series.create!(title: "Trilogy")
  book1 = Book.create!(title: "Alpha", parent_id: series.id, position: 1)
  book2 = Book.create!(title: "Beta", parent_id: series.id, position: 1)
  child1 = Chapter.create!(title: "Prologue", parent_id: book1.id, position: 1, url: "http://test.sidrasue.com/parts/1.html")
  child2 = Chapter.create!(title: "Epilogue", parent_id: book2.id, position: 1, url: "http://test.sidrasue.com/parts/5.html")

end
