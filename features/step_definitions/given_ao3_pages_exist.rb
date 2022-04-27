Given /^Open the Door exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/310586")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.raw_html = File.open(Rails.root + "features/html/open1.html", 'r:utf-8') { |f| f.read }
  chapter1.update!(url: "https://archiveofourown.org/works/310586/chapters/497361")
  chapter1.get_meta_from_ao3(false)
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.raw_html = File.open(Rails.root + "features/html/open2.html", 'r:utf-8') { |f| f.read }
  chapter2.update!(url: "https://archiveofourown.org/works/310586/chapters/757306")
  chapter2.get_meta_from_ao3(false)
  page.get_meta_from_ao3(false)
end

Given /^Where am I exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  page.raw_html = File.open(Rails.root + "features/html/where.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Where am I existed and was read$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  page.raw_html = File.open(Rails.root + "features/html/where.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
  page.read_today.rate(5).update_read_after
end

Given /^Fuuinjutsu exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/36425557")
  page.raw_html = File.open(Rails.root + "features/html/Fuuinjutsu.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^I Drive Myself Crazy exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/68481")
  page.raw_html = File.open(Rails.root + "features/html/drive.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Time Was exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.raw_html = File.open(Rails.root + "features/html/where.html", 'r:utf-8') { |f| f.read }
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.get_meta_from_ao3(false)
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.raw_html = File.open(Rails.root + "features/html/hogwarts.html", 'r:utf-8') { |f| f.read }
  chapter2.update!(url: "https://archiveofourown.org/works/692/chapters/804")
  chapter2.get_meta_from_ao3(false)
  page.get_meta_from_ao3(false).set_tags
end

Given /^Time Was partially exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.raw_html = File.open(Rails.root + "features/html/where.html", 'r:utf-8') { |f| f.read }
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.get_meta_from_ao3(false)
  chapter1.read_today.rate("3").update_read_after
  page.get_meta_from_ao3(false).set_tags.cleanup(false)
end

Given /^Bad Formatting exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/23477578")
  page.raw_html = File.open(Rails.root + "features/html/notes.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Quoted Notes exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/22989676/chapters/54962869")
  page.raw_html = File.open(Rails.root + "features/html/quotes.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Multi Authors exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/29253276/chapters/71833074")
  page.raw_html = File.open(Rails.root + "features/html/multi.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Skipping Stones exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/688")
  page.raw_html = File.open(Rails.root + "features/html/skipping.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Counting Drabbles exists$/ do
  series = Series.create!(title: "Counting Drabbles")
  series.update!(url: "https://archiveofourown.org/series/46")
  series.raw_html = File.open(Rails.root + "features/html/drabbles.html", 'r:utf-8') { |f| f.read }

  work1 = Single.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "https://archiveofourown.org/works/688")
  work1.raw_html = File.open(Rails.root + "features/html/skipping.html", 'r:utf-8') { |f| f.read }
  work1.get_meta_from_ao3(false)

  work2 = Single.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/689")
  work2.raw_html = File.open(Rails.root + "features/html/flower.html", 'r:utf-8') { |f| f.read }
  work2.get_meta_from_ao3(false)

  series.get_meta_from_ao3(false).set_wordcount(false)
end

Given /^Counting Drabbles partially exists$/ do
  series = Series.create!(title: "Counting Drabbles")
  series.update!(url: "https://archiveofourown.org/series/46")
  series.raw_html = File.open(Rails.root + "features/html/partial.html", 'r:utf-8') { |f| f.read }

  work1 = Single.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "https://archiveofourown.org/works/688")
  work1.raw_html = File.open(Rails.root + "features/html/skipping.html", 'r:utf-8') { |f| f.read }
  work1.set_wordcount.get_meta_from_ao3(false)
  work1.read_today.rate(5).update_read_after

  series.get_meta_from_ao3(false).set_wordcount(false).update_read_after
end

Given /^Alan Rickman exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/5720104")
  page.raw_html = File.open(Rails.root + "features/html/alan.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Misfits existed$/ do
  series = Series.create!(title: "Misfit Series")

  work1 = Book.create!(title: "temp", parent_id: series.id, position: 1)
  chapter1 = Chapter.create!(title: "temp", parent_id: work1.id, position: 1)
  chapter1.raw_html = File.open(Rails.root + "features/html/misfits1.html", 'r:utf-8') { |f| f.read }
  chapter1.update!(url: "https://archiveofourown.org/works/4945936/chapters/11353174")
  chapter1.get_meta_from_ao3(false)
  chapter2 = Chapter.create!(title: "temp", parent_id: work1.id, position: 2)
  chapter2.raw_html = File.open(Rails.root + "features/html/misfits2.html", 'r:utf-8') { |f| f.read }
  chapter2.update!(url: "https://archiveofourown.org/works/4945936/chapters/11369638")
  chapter2.get_meta_from_ao3(false)
  work1.get_meta_from_ao3(false)

  work2 = Book.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/13765827")
  chapter3 = Chapter.create!(title: "temp", parent_id: work2.id, position: 1)
  chapter3.raw_html = File.open(Rails.root + "features/html/misfits3.html", 'r:utf-8') { |f| f.read }
  chapter3.update!(url: "https://archiveofourown.org/works/13765827/chapters/31637625")
  chapter3.get_meta_from_ao3(false)
  chapter4 = Chapter.create!(title: "temp", parent_id: work2.id, position: 2)
  chapter4.raw_html = File.open(Rails.root + "features/html/misfits4.html", 'r:utf-8') { |f| f.read }
  chapter4.update!(url: "https://archiveofourown.org/works/13765827/chapters/33586779")
  chapter4.get_meta_from_ao3(false)
  work2.get_meta_from_ao3(false)
  work2.update!(url: "https://archiveofourown.org/works/13765827")

end

Given('Misfits has a URL') do
  page = Series.first
  page.update!(url: "https://archiveofourown.org/series/334075")
end

Given /^Yer a Wizard exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/35386909")
  page.raw_html = File.open(Rails.root + "features/html/yer.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^The Picture exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/9381749/chapters/21239633")
  page.raw_html = File.open(Rails.root + "features/html/picture.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Prologue exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/7755808/chapters/17685394")
  page.raw_html = File.open(Rails.root + "features/html/prologue.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given('Wheel exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/1115355")
  page.raw_html = File.open(Rails.root + "features/html/wheel.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given('wip exists') do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38044144")
  chapter2 = Chapter.create!(title: "temp", parent_id: page.id, position: 2)
  chapter2.raw_html = File.open(Rails.root + "features/html/wip.html", 'r:utf-8') { |f| f.read }
  chapter2.update!(url: "https://archiveofourown.org/works/38044144/chapters/95026165")
  chapter2.get_meta_from_ao3(false)
  page.get_meta_from_ao3(false).set_tags
end

Given('The Right Path exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://archiveofourown.org/works/5571483")
  page.raw_html = File.open(Rails.root + "features/html/right.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given('Brave New World exists') do
  book = Book.create!(title: "temp")
  book.update!(url: "https://archiveofourown.org/works/23295031")
  chapter1 = Chapter.create!(title: "temp", parent_id: book.id, position: 1)
  chapter1.raw_html = File.open(Rails.root + "features/html/brave1.html", 'r:utf-8') { |f| f.read }
  chapter1.update!(url: "https://archiveofourown.org/works/23295031/chapters/55791421")
  chapter1.get_meta_from_ao3(false)
  chapter2 = Chapter.create!(title: "temp", parent_id: book.id, position: 2)
  chapter2.raw_html = File.open(Rails.root + "features/html/brave2.html", 'r:utf-8') { |f| f.read }
  chapter2.update!(url: "https://archiveofourown.org/works/23295031/chapters/56053450")
  chapter2.get_meta_from_ao3(false)
  book.get_meta_from_ao3(false).set_tags
end

Given('Iterum Rex exists') do
  series = Series.create!(title: "Iterum Rex")
  series.update!(url: "http://archiveofourown.org/series/1005861")
  step "Brave New World exists"
  book = Book.find_by_title("Brave New World")
  book.update!(parent_id: series.id, position: 2)
end
