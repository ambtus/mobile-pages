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

Given /^I Drive Myself Crazy exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "http://archiveofourown.org/works/68481")
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
  page.get_meta_from_ao3(false)
end

Given /^Time Was partially exists$/ do
  page = Book.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/692")
  chapter1 = Chapter.create!(title: "temp", parent_id: page.id, position: 1)
  chapter1.raw_html = File.open(Rails.root + "features/html/where.html", 'r:utf-8') { |f| f.read }
  chapter1.update!(url: "https://archiveofourown.org/works/692/chapters/803")
  chapter1.get_meta_from_ao3(false)
  chapter2 = Chapter.create!(title: "fake", parent_id: page.id, position: 2)
  page.get_meta_from_ao3(false)
  page.rate("3")
end

Given /^Bad Formatting exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/23477578")
  page.raw_html = File.open(Rails.root + "features/html/notes.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Quoted Notes exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "http://archiveofourown.org/works/22989676/chapters/54962869")
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
  page.update!(url: "http://archiveofourown.org/works/688/")
  page.raw_html = File.open(Rails.root + "features/html/skipping.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end

Given /^Counting Drabbles exists$/ do
  series = Series.create!(title: "Counting Drabbles")

  work1 = Single.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "http://archiveofourown.org/works/688")
  work1.raw_html = File.open(Rails.root + "features/html/skipping.html", 'r:utf-8') { |f| f.read }
  work1.get_meta_from_ao3(false)

  work2 = Single.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/689")
  work2.raw_html = File.open(Rails.root + "features/html/flower.html", 'r:utf-8') { |f| f.read }
  work2.get_meta_from_ao3(false)

  series.set_wordcount
end

Given /^Alan Rickman exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/5720104")
  page.raw_html = File.open(Rails.root + "features/html/alan.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end


Given /^Misfits exists$/ do
  series = Series.create!(title: "Misfit Series")

  work1 = Book.create!(title: "temp", parent_id: series.id, position: 1)
  chapter1 = Chapter.create!(title: "temp", parent_id: work1.id, position: 1)
  chapter1.raw_html = File.open(Rails.root + "features/html/misfits1.html", 'r:utf-8') { |f| f.read }
  chapter1.update!(url: "http://archiveofourown.org/works/4945936/chapters/11353174")
  chapter1.get_meta_from_ao3(false)
  chapter2 = Chapter.create!(title: "temp", parent_id: work1.id, position: 2)
  chapter2.raw_html = File.open(Rails.root + "features/html/misfits2.html", 'r:utf-8') { |f| f.read }
  chapter2.update!(url: "http://archiveofourown.org/works/4945936/chapters/11369638")
  chapter2.get_meta_from_ao3(false)
  work1.get_meta_from_ao3(false)

  work2 = Book.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "https://archiveofourown.org/works/13765827")
  chapter3 = Chapter.create!(title: "temp", parent_id: work2.id, position: 1)
  chapter3.raw_html = File.open(Rails.root + "features/html/misfits3.html", 'r:utf-8') { |f| f.read }
  chapter3.update!(url: "http://archiveofourown.org/works/13765827/chapters/31637625")
  chapter3.get_meta_from_ao3(false)
  chapter4 = Chapter.create!(title: "temp", parent_id: work2.id, position: 2)
  chapter4.raw_html = File.open(Rails.root + "features/html/misfits4.html", 'r:utf-8') { |f| f.read }
  chapter4.update!(url: "http://archiveofourown.org/works/13765827/chapters/33586779")
  chapter4.get_meta_from_ao3(false)
  work2.get_meta_from_ao3(false)
  work2.update!(url: "http://archiveofourown.org/works/13765827/")

  series.set_wordcount
end

Given /^Yer a Wizard exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/35386909")
  page.raw_html = File.open(Rails.root + "features/html/yer.html", 'r:utf-8') { |f| f.read }
  page.get_meta_from_ao3(false)
end
