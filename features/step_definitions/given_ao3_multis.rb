Given /^Open the Door exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/310586")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/310586/chapters/497361")
  chapter1.set_raw_from("open1")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/310586/chapters/757306")
  chapter2.set_raw_from("open2")
  page.rebuild_meta
end

Given /^Time Was existed$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.set_raw_from("where")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/692/chapters/804")
  chapter2.set_raw_from("hogwarts")
  page.rebuild_meta
  page.update_from_parts
end

Given /^Time Was exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.set_raw_from("where_new")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/692/chapters/804")
  chapter2.set_raw_from("hogwarts_new")
  page.rebuild_meta
  page.update_from_parts
end

Given /^Time Was partially exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.set_raw_from("where").rate_today("3")
  page.rebuild_meta
  page.update_from_parts
end

Given /^I add the second chapter manually$/ do
  chapter2 = Single.create!(title: "temp")
  chapter2.update!(url: "https://archiveofourown.org/works/692/chapters/804")
  chapter2.set_raw_from("hogwarts_new")
end

Given /^Counting Drabbles exists$/ do
  series = Series.create!(title: "Counting Drabbles")
  series.update!(url: "https://archiveofourown.org/series/46")
  series.set_raw_from("drabbles")

  work1 = Single.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "https://archiveofourown.org/works/688")
  work1.set_raw_from("skipping")

  work2 = Single.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/689")
  work2.set_raw_from("flower")
  series.update_from_parts
  series.rebuild_meta
end

Given /^Counting Drabbles exists without a URL$/ do
  series = Series.create!(title: "Counting Drabbles")

  work1 = Single.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "https://archiveofourown.org/works/688")
  work1.set_raw_from("skipping")

  work2 = Single.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/689")
  work2.set_raw_from("flower")

  series.rebuild_meta
end

Given /^Counting Drabbles partially exists$/ do
  series = Series.create!(title: "Counting Drabbles")
  series.update!(url: "https://archiveofourown.org/series/46")
  series.set_raw_from("partial")

  work1 = Single.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "https://archiveofourown.org/works/688")
  work1.set_raw_from("skipping").rate_today(5)

  series.set_meta.set_wordcount(false).update_read_after
end

Given /^broken Drabbles exists$/ do
  series = Series.create!(title: "Counting Drabbles")
  series.update!(url: "https://archiveofourown.org/series/46")
  series.set_raw_from("partial")

  work1 = Chapter.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "https://archiveofourown.org/works/688")
  work1.set_raw_from("skipping")
end

Given /^Misfits existed$/ do
  series = Series.create!(title: "Misfit Series")

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

  series.rebuild_meta
  series.update_from_parts
end

Given('Misfits has a URL') do
  page = Series.first
  page.update!(url: "https://archiveofourown.org/series/334075")
end

Given('wip exists') do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38044144")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/38044144/chapters/95026165")
  chapter2.set_raw_from("wip")
  page.rebuild_meta
end

Given('Brave New World exists') do
  book = Book.create!(title: "temp")
  book.update!(url: "https://archiveofourown.org/works/23295031")
  chapter1 = Chapter.create!(title: "temp", parent_id: book.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/23295031/chapters/55791421")
  chapter1.set_raw_from("brave1")
  chapter2 = Chapter.create!(title: "temp", parent_id: book.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/23295031/chapters/56053450")
  chapter2.set_raw_from("brave2")
  book.rebuild_meta
end

Given('Iterum Rex exists') do
  series = Series.create!(title: "Iterum Rex")
  series.update!(url: "http://archiveofourown.org/series/1005861")
  step "Brave New World exists"
  book = Book.find_by_title("Brave New World")
  book.update!(parent_id: series.id, position: 2)
  series.rebuild_meta
end

Given('Cold Water exists') do
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
end

Given('that was partially exists') do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38244064")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/38244064/chapters/95553088")
  chapter1.set_raw_from("that")
  page.set_meta
end

Given('New Day Dawning exists') do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38952696")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/38952696/chapters/97419789")
  chapter1.set_raw_from("end_notes")
  page.set_meta
end

Given('fire exists') do
  book = Book.create!(title: "temp")
  book.update!(url: "https://archiveofourown.org/works/26249209")
  chapter1 = Chapter.create!(title: "temp", parent_id: book.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/26249209/chapters/63892810")
  chapter1.set_raw_from("fire1")
  chapter2 = Chapter.create!(title: "temp", parent_id: book.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/26249209/chapters/63897259")
  chapter2.set_raw_from("fire2")
  book.set_meta
end

Given /^Misfits first chapter of second work exists$/ do
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

  work2 = Single.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/13765827")
  work2.set_raw_from("misfits3")
  work2.rebuild_meta

end

Given /^Mandalorian Zuko exists$/ do
  series = Series.create!(title: "Mandalorian Zuko")
  series.update!(url: "https://archiveofourown.org/series/1820452")

  book1 = Book.create!(title: "temp", parent_id: series.id, position: 1)
  book1.update!(url: "https://archiveofourown.org/works/25131619")
  chapter1 = Chapter.create!(title: "temp", parent_id: book1.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/25131619/chapters/60890896")
  chapter1.set_raw_from("meeting")
  book1.rebuild_meta
  book1.update_from_parts

  single = Single.create!(title: "temp", parent_id: series.id, position: 2)
  single.update!(url: "https://archiveofourown.org/works/25534093")
  single.set_raw_from("mandalorian")

  series.update_from_parts

end
