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

Given /^Where am I exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  page.set_raw_from("where")
end

Given /^Where am I existed and was read$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  page.set_raw_from("where").rate_today(5)
end

Given /^Fuuinjutsu exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/36425557")
  page.set_raw_from("Fuuinjutsu")
end

Given /^I Drive Myself Crazy exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/68481")
  page.set_raw_from("drive")
end

Given /^Time Was exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.set_raw_from("where")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/692/chapters/804")
  chapter2.set_raw_from("hogwarts")
  page.rebuild_meta
end

Given /^Time Was partially exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.set_raw_from("where").rate_today("3")
  page.set_meta
end

Given /^Bad Formatting exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/23477578")
  page.set_raw_from("notes")
end

Given /^Quoted Notes exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/22989676/chapters/54962869")
  page.set_raw_from("quotes")
end

Given /^Multi Authors exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/29253276/chapters/71833074")
  page.set_raw_from("multi")
end

Given /^Skipping Stones exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/688")
  page.set_raw_from("skipping")
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

Given /^Alan Rickman exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/5720104")
  page.set_raw_from("alan")
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

end

Given('Misfits has a URL') do
  page = Series.first
  page.update!(url: "https://archiveofourown.org/series/334075")
end

Given /^Yer a Wizard exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/35386909")
  page.set_raw_from("yer")
end

Given /^The Picture exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/9381749/chapters/21239633")
  page.set_raw_from("picture")
end

Given /^Prologue exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/7755808/chapters/17685394")
  page.set_raw_from("prologue")
end

Given('Wheel exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/1115355")
  page.set_raw_from("wheel")
end

Given('wip exists') do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38044144")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.update!(url: "https://archiveofourown.org/works/38044144/chapters/95026165")
  chapter2.set_raw_from("wip")
  page.rebuild_meta
end

Given('The Right Path exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://archiveofourown.org/works/5571483")
  page.set_raw_from("right")
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

Given('had a heart exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/18246218")
  page.set_raw_from("heart")
end

Given('New Day Dawning exists') do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38952696")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.update!(url: "https://archiveofourown.org/works/38952696/chapters/97419789")
  chapter1.set_raw_from("end_notes")
  page.set_meta
end
