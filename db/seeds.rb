Fandom.find_or_create_by!(name: "Harry Potter")
Fandom.find_or_create_by!(name: "Teen Wolf")
Fandom.find_or_create_by!(name: "Shadowhunters")
Fandom.find_or_create_by!(name: "Naruto")
Fandom.find_or_create_by!(name: "Popslash")
Fandom.find_or_create_by!(name: "Star Wars")
Fandom.find_or_create_by!(name: "Drizzt (Forgotten Realms)")
Author.find_or_create_by!(name: "Sidra (ambtus)")
Author.find_or_create_by!(name: "Claire Watson")
Author.find_or_create_by!(name: "adiduck (book_people)")


# given_ao3_pages.rb without the Given...end lines and without dupes

  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/310586")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/310586/chapters/497361")
  chapter1.set_raw_from("open1")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/310586/chapters/757306")
  chapter2.set_raw_from("open2")
  page.rebuild_meta

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/36425557")
  page.set_raw_from("Fuuinjutsu")

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/68481")
  page.set_raw_from("drive")

  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.set_raw_from("where")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/692/chapters/804")
  chapter2.set_raw_from("hogwarts")
  page.rebuild_meta

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/23477578")
  page.set_raw_from("notes")

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/22989676/chapters/54962869")
  page.set_raw_from("quotes")

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/29253276/chapters/71833074")
  page.set_raw_from("multi")

  series = Series.create!(title: "Counting Drabbles")
  series.update!(url: "https://archiveofourown.org/series/46")
  series.set_raw_from("drabbles")

  work1 = Single.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "https://archiveofourown.org/works/688")
  work1.set_raw_from("skipping")

  work2 = Single.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/689")
  work2.set_raw_from("flower")

  series.rebuild_meta.set_wordcount(false)

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/5720104")
  page.set_raw_from("alan")

  series = Series.create!(title: "Misfit Series")
  series.update!(url: "https://archiveofourown.org/series/334075")

  work1 = Book.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "https://archiveofourown.org/works/4945936")
  chapter1 = Chapter.create!(title: "temp", parent_id: work1.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/4945936/chapters/11353174")
  chapter1.set_raw_from("misfits1")
  chapter2 = Chapter.create!(title: "temp", parent_id: work1.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/4945936/chapters/11369638")
  chapter2.set_raw_from("misfits2")
  work1.rebuild_meta

  work2 = Book.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/13765827")
  chapter3 = Chapter.create!(title: "temp", parent_id: work2.id, position: 1)
  chapter3.update!(url: "https://archiveofourown.org/works/13765827/chapters/31637625")
  chapter3.set_raw_from("misfits3")
  chapter4 = Chapter.create!(title: "temp", parent_id: work2.id, position: 2)
  chapter4.update!(url: "https://archiveofourown.org/works/13765827/chapters/33586779")
  chapter4.set_raw_from("misfits4")
  work2.rebuild_meta

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/35386909")
  page.set_raw_from("yer")

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/9381749/chapters/21239633")
  page.set_raw_from("picture")

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/7755808/chapters/17685394")
  page.set_raw_from("prologue")

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/1115355")
  page.set_raw_from("wheel")

  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38044144")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/38044144/chapters/95026165")
  chapter2.set_raw_from("wip")
  page.rebuild_meta

  page = Single.create!(title: "temp")
  page.update!(url: "http://archiveofourown.org/works/5571483")
  page.set_raw_from("right")

  book = Book.create!(title: "temp")
  book.update!(url: "https://archiveofourown.org/works/23295031")
  chapter1 = Chapter.create!(title: "temp", parent_id: book.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/23295031/chapters/55791421")
  chapter1.set_raw_from("brave1")
  chapter2 = Chapter.create!(title: "temp", parent_id: book.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/23295031/chapters/56053450")
  chapter2.set_raw_from("brave2")
  book.rebuild_meta

  series = Series.create!(title: "Iterum Rex")
  series.update!(url: "http://archiveofourown.org/series/1005861")
  book.update!(parent_id: series.id, position: 2)

  book = Book.create!(title: "temp")
  book.update!(url: "https://archiveofourown.org/works/37716514")
  chapter1 = Chapter.create!(title: "temp", parent_id: book.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/37716514/chapters/94161631")
  chapter1.set_raw_from("one")
  chapter2 = Chapter.create!(title: "temp", parent_id: book.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/37716514/chapters/94181914")
  chapter2.set_raw_from("three")
  chapter3 = Chapter.create!(title: "temp", parent_id: book.id, position: 3)
  chapter3.update!(url: "https://archiveofourown.org/works/37716514/chapters/94266751")
  chapter3.set_raw_from("five")
  book.rebuild_meta

  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38244064")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/38244064/chapters/95553088")
  chapter1.set_raw_from("that")
  page.set_meta

  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/18246218")
  page.set_raw_from("heart")

  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38952696")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/38952696/chapters/97419789")
  chapter1.set_raw_from("end_notes")
  page.set_meta

# given_ff_and_cn.rb without the Given...end lines and without dupes

  page = Single.create!(url: "https://www.fanfiction.net/s/5409165/6/It-s-For-a-Good-Cause-I-Swear")
  page.set_raw_from("part6")

  page = Book.create!(base_url: "https://www.fanfiction.net/s/2652996/*", url_substitutions: "1")
  page.parts.first.set_raw_from("stuck1")
  page.rebuild_meta.set_wordcount(false)

  page = Single.create!(url: "https://www.fanfiction.net/s/6783401/1/Ibiki-s-Apprentice")
  page.set_raw_from("ibiki")

  page = Book.create!(base_url: "https://www.fanfiction.net/s/5853866/*/Counting", url_substitutions: "1-2")
  page.parts.first.set_raw_from("counting1")
  page.parts.second.set_raw_from("counting2")
  page.rebuild_meta.set_wordcount(false)

  page = Book.create!(base_url: "http://www.fanfiction.net/s/2790804/*", url_substitutions: "1-78")
  chapter1 = page.parts.first
  chapter1.update title: "Introduction", notes: "This story takes place in an Alternate Universe"
  chapter1.set_raw_from("intro")
  chapter3 = page.parts.third
  chapter3.update title: "First Year"
  chapter3.set_raw_from("first")
  page.parts.last.set_raw_from("78")
  page.rebuild_meta

  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/the-resolute-urgency-of-now-time-travel-trope-bingo-2020-2021/")
  page.set_raw_from("urgency")

  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/time-after-time/")
  page.set_raw_from("time")

  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/bingo/i-wish-amnesia-trope-bingo-2020-2021/")
  page.set_raw_from("wish")

  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/the-secret-to-survivin/")
  page.set_raw_from("secret")

  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/crazy-little-thing/")
  page.set_raw_from("crazy")

  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/something-in-my-liberty/")
  page.set_raw_from("something")

  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/almost-paradise-art-by-fashi0n/")
  page.set_raw_from("art")

  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/black-moon-rising/")
  page.set_raw_from("black")

# given_pages_with_all.rb without the Given...end lines

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

  Page.create(title: "page4").rate_today(4)
  Page.create(title: "page0")
  Page.create(title: "page1").rate_today(1)
  Page.create(title: "page3").rate_today(3)
  Page.create(title: "page5").rate_today(5)
  Page.create(title: "page9").rate_today(9)
  Page.create(title: "page2").rate_today(2)

  Page.create(title: "now reading", soon: 0)
  Page.create(title: "read next", soon: 1)
  Page.create(title: "read soon", soon: 2)
  Page.create(title: "default", soon: 3)
  Page.create(title: "read later", soon: 4)
  Page.create(title: "read eventually", soon: 5)

  Page.create(title: "Medium", url: "file:///#{Rails.root}/tmp/html/long.html")
  Page.create(title: "Drabble").raw_html=100.times.collect{|i| (i+1).to_s}.join(" ")
  Page.create(title: "Long2", base_url: "file:///#{Rails.root}/tmp/html/long*.html", url_substitutions: "1-9")
  Page.create(title: "Short", url: "file:///#{Rails.root}/tmp/html/short.html")
  Page.create(title: "Long", url: "file:///#{Rails.root}/tmp/html/40000.html")
  Page.create(title: "Epic", base_url: "file:///#{Rails.root}/tmp/html/epic*.html", url_substitutions: "1-9")
  Page.create(title: "Medium2", base_url: "file:///#{Rails.root}/tmp/html/medium*.html", url_substitutions: "1-5")

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

  interesting = Pro.find_or_create_by(name: "interesting")
  boring = Con.find_or_create_by(name: "boring")
  loving = Pro.find_or_create_by(name: "loving")
  hateful = Con.find_or_create_by(name: "hateful")
  Page.find_or_create_by(title: "page1").tags << [hateful, boring]
  Page.find_or_create_by(title: "page2h").tags << hateful
  Page.find_or_create_by(title: "page2b").tags << boring
  Page.find_or_create_by(title: "page3")
  Page.find_or_create_by(title: "page3l").tags << [boring,loving]
  Page.find_or_create_by(title: "page3h").tags << [hateful,interesting]
  Page.find_or_create_by(title: "page4l").tags << loving
  Page.find_or_create_by(title: "page4i").tags << interesting
  Page.find_or_create_by(title: "page5").tags << [interesting, loving]
  Con.recache_all

