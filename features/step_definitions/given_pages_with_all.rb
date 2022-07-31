Given("pages with all possible types exist") do
  Single.create(title: "One-shot", url: "http://test.sidrasue.com/short.html")
  Book.create(title: "Novel", base_url: "http://test.sidrasue.com/long*.html", url_substitutions: "1-2")

  Kernel::sleep 1
  series = Series.create!(title: "Trilogy")
  book1 = Book.create!(title: "Alpha", parent_id: series.id, position: 1)
  book2 = Book.create!(title: "Beta", parent_id: series.id, position: 2)
  child1 = Chapter.create!(title: "Prologue", parent_id: book1.id, position: 1, url: "http://test.sidrasue.com/parts/1.html")
  child2 = Chapter.create!(title: "Epilogue", parent_id: book2.id, position: 1, url: "http://test.sidrasue.com/parts/5.html")

  Kernel::sleep 1
  collection = Collection.create!(title: "Life's Work")

  Single.create(title: "First", url: "http://test.sidrasue.com/test.html", parent_id: collection.id, position: 1)
  Book.create(title: "Second", base_url: "http://test.sidrasue.com/medium*.html", url_substitutions: "1-2", parent_id: collection.id, position: 2)
  series2 = Series.create(title: "Third", parent_id: collection.id, position: 3)
  Book.create(title: "Fourth", parent_id: series2.id, position: 1)
  Book.create(title: "Fifth", parent_id: series2.id, position: 2)
end

Given("pages with all possible stars exist") do
  Page.create(title: "page4").rate_today(4)
  Page.create(title: "page0")
  Page.create(title: "page1").rate_today(1)
  Page.create(title: "page3").rate_today(3)
  Page.create(title: "page5").rate_today(5)
  Page.create(title: "page9").rate_today(9)
  Page.create(title: "page2").rate_today(2)
end

Given("pages with all possible soons exist") do
  Page.create(title: "now reading", soon: -1)
  Page.create(title: "read next", soon: 0)
  Page.create(title: "read sooner", soon: 1)
  Page.create(title: "read soon", soon: 2)
  Page.create(title: "default", soon: 3)
  Page.create(title: "read later", soon: 4)
  Page.create(title: "read eventually", soon: 5)
end

Given("pages with all possible sizes exist") do
  Page.create(title: "Medium", url: "file:///#{Rails.root}/tmp/html/long.html")
  Page.create(title: "Drabble").raw_html=100.times.collect{|i| (i+1).to_s}.join(" ")
  Page.create(title: "Long2", base_url: "file:///#{Rails.root}/tmp/html/long*.html", url_substitutions: "1-9")
  Page.create(title: "Short", url: "file:///#{Rails.root}/tmp/html/short.html")
  Page.create(title: "Long", url: "file:///#{Rails.root}/tmp/html/40000.html")
  Page.create(title: "Epic", base_url: "file:///#{Rails.root}/tmp/html/epic*.html", url_substitutions: "1-9")
  Page.create(title: "Medium2", base_url: "file:///#{Rails.root}/tmp/html/medium*.html", url_substitutions: "1-5")
end

Given("pages with all possible unreads exist") do
  Single.create(title: "not read single")
  Single.create(title: "yes read single",).rate_today(5)

  book1 = Book.create(title: "not read book")
  Chapter.create(title: "not read chapter", parent_id: book1.id)
  book1.update_from_parts

  book2 = Book.create(title: "yes read book")
  Chapter.create(title: "yes read chapter", parent_id: book2.id).rate_today(5)
  book2.update_from_parts

  book3 = Book.create(title: "partially read book")
  Chapter.create(title: "not read chapter", parent_id: book3.id)
  Chapter.create(title: "yes read chapter", parent_id: book3.id).rate_today(5)
  book3.update_from_parts

  series1 = Series.create(title: "not read series")
  book4 = Book.create(title: "another not read book", parent_id: series1.id)
  Chapter.create(title: "another not read chapter", parent_id: book4.id)
  book4.update_from_parts
  series1.update_from_parts

  series2 = Series.create(title: "partially read series")
  book5 = Book.create(title: "another partially read book", parent_id: series2.id)
  Chapter.create(title: "yet another not read chapter", parent_id: book5.id)
  Chapter.create(title: "another read chapter", parent_id: book5.id).rate_today(5)
  book5.update_from_parts
  series2.update_from_parts

  series3 = Series.create(title: "yes read series")
  book6 = Book.create(title: "another read book", parent_id: series3.id)
  Chapter.create(title: "another read chapter", parent_id: book6.id).rate_today(5)
  book6.update_from_parts
  series3.update_from_parts
end

Given("pages with all combinations of pros and cons exist") do
  interesting = Pro.find_or_create_by(name: "interesting")
  boring = Con.find_or_create_by(name: "boring")
  loving = Pro.find_or_create_by(name: "loving")
  hateful = Con.find_or_create_by(name: "hateful")
  Page.find_or_create_by(title: "page1").tags << [hateful, boring]
  Page.find_or_create_by(title: "page2h").tags << hateful
  Page.find_or_create_by(title: "page2b").tags << boring
  Page.find_or_create_by(title: "page3d")
  Page.find_or_create_by(title: "page3l").tags << [boring,loving]
  Page.find_or_create_by(title: "page3h").tags << [hateful,interesting]
  Page.find_or_create_by(title: "page4l").tags << loving
  Page.find_or_create_by(title: "page4i").tags << interesting
  Page.find_or_create_by(title: "page5").tags << [interesting, loving]
  Con.recache_all
  Pro.recache_all
end

