# frozen_string_literal: true

Given(/^Open the Door exists$/) do
  chapter1 = create_local_page 'open1', 'https://archiveofourown.org/works/310586/chapters/497361'
  chapter2 = create_local_page 'open2', 'https://archiveofourown.org/works/310586/chapters/757306'
  book = local_page url: 'https://archiveofourown.org/works/310586'
  book.add_chapter chapter1.url
  book.add_chapter chapter2.url
  book.rebuild_meta
end

Given(/^Time Was partially exists$/) do
  chapter = create_first_chapter
  book = local_page url: 'https://archiveofourown.org/works/692'
  book.add_chapter chapter.url
  book.rebuild_meta
  book.rate_today(5)
end

Given(/^Time Was existed$/) do
  create_book_with_old_html
end

Given(/^Time Was exists$/) do
  create_book
end

Given(/^I add the second chapter manually$/) do
  create_second_chapter
end

Given(/^Counting Drabbles exists$/) do
  create_series
end

Given(/^Counting Drabbles had tags$/) do
  page = Series.first
  page.tags << [fandom, author]
end

Given(/^Counting Drabbles existed$/) do
  s1 = create_first_single
  s2 = create_second_single
  series = Series.create!(title: 'Counting Drabbles')
  series.add_part s1.url
  series.add_part s2.url
end

Given(/^Counting Drabbles partially exists$/) do
  work1 = create_first_single
  work1.rate_today(5)
  series = create_local_parent 'partial', 'https://archiveofourown.org/series/46'
  series.rebuild_meta
  series.update_from_parts
end

Given(/^broken Drabbles exists$/) do
  work = create_local_page 'skipping', 'https://archiveofourown.org/works/688'
  create_local_parent 'partial', 'https://archiveofourown.org/series/46'
  work.update(type: Chapter)
end

# before series had urls
Given(/^Misfits existed$/) do
  create_local_page 'misfits1', 'https://archiveofourown.org/works/4945936/chapters/11353174'
  create_local_page 'misfits2', 'https://archiveofourown.org/works/4945936/chapters/11369638'
  work1 = local_page url: 'https://archiveofourown.org/works/4945936'
  work1.add_part(Page.first.url)
  work1.add_part(Page.second.url)
  work1.rebuild_meta

  create_local_page 'misfits3', 'https://archiveofourown.org/works/13765827/chapters/31637625'
  create_local_page 'misfits4', 'https://archiveofourown.org/works/13765827/chapters/33586779'

  work2 = local_page  url: 'https://archiveofourown.org/works/13765827'
  work2.add_part(Page.fourth.url)
  work1.add_part(Page.fifth.url)
  work2.rebuild_meta

  series = Series.create!(title: 'Misfit Series')
  series.add_part(work1.url)
  series.add_part(work2.url)
end

Given('Misfits has a URL') do
  page = Series.first
  page.update!(url: 'https://archiveofourown.org/series/334075')
end

Given('wip exists') do
  book = local_page  url: 'https://archiveofourown.org/works/38044144'
  ch2 = create_local_page 'wip', 'https://archiveofourown.org/works/38044144/chapters/95026165'
  book.add_chapter ch2.url
  book.rebuild_meta
end

Given('Brave New World exists') do
  book = local_page url: 'https://archiveofourown.org/works/23295031'
  chapter1 = create_local_page 'brave1', 'https://archiveofourown.org/works/23295031/chapters/55791421'
  book.add_chapter chapter1.url
  chapter2 = create_local_page 'brave2', 'https://archiveofourown.org/works/23295031/chapters/56053450'
  book.add_chapter chapter2.url
  book.rebuild_meta
end

Given('Iterum Rex exists') do
  series = local_page url: 'http://archiveofourown.org/series/1005861'
  series.update(title: 'Iterum Rex')
  step 'Brave New World exists'
  book = Book.find_by(title: 'Brave New World')
  book.update!(parent_id: series.id, position: 2)
  series.rebuild_meta
end

Given('Cold Water exists') do
  book = local_page url: 'https://archiveofourown.org/works/37716514'
  chapter1 = create_local_page('one', 'https://archiveofourown.org/works/37716514/chapters/94161631')
  book.add_chapter chapter1.url
  chapter2 = create_local_page 'three', 'https://archiveofourown.org/works/37716514/chapters/94181914'
  book.add_chapter chapter2.url
  chapter3 = create_local_page 'five', 'https://archiveofourown.org/works/37716514/chapters/94266751'
  book.add_chapter chapter3.url
  book.rebuild_meta
end

Given('that was partially exists') do
  book = local_page url: 'https://archiveofourown.org/works/38244064'
  chapter1 = create_local_page 'that', 'https://archiveofourown.org/works/38244064/chapters/95553088'
  book.add_chapter chapter1.url
  book.rebuild_meta
end

Given('New Day Dawning exists') do
  book = local_page url: 'https://archiveofourown.org/works/38952696'
  chapter1 = create_local_page 'end_notes', 'https://archiveofourown.org/works/38952696/chapters/97419789'
  book.add_chapter chapter1.url
  book.rebuild_meta
end

Given('fire exists') do
  book = Book.create!(title: 'temp', url: 'https://archiveofourown.org/works/26249209')
  chapter1 = create_local_page 'fire1', 'https://archiveofourown.org/works/26249209/chapters/63892810'
  book.add_chapter chapter1.url
  chapter1.reload && chapter1.set_meta
  chapter2 = create_local_page 'fire2', 'https://archiveofourown.org/works/26249209/chapters/63897259'
  book.add_chapter chapter2.url
  chapter2.reload && chapter2.set_meta
  book.set_meta && book.update_from_parts
end

Given(/^Misfits first chapter of second work exists$/) do
  series = Series.create!(title: 'Misfit Series')
  series.update!(url: 'https://archiveofourown.org/series/334075')

  work1 = Book.create!(title: 'temp', parent_id: series.id, position: 1)
  work1.update!(url: 'https://archiveofourown.org/works/4945936')
  chapter1 = Chapter.create!(title: 'temp', parent_id: work1.id, position: 1)
  chapter1.update!(url: 'https://archiveofourown.org/works/4945936/chapters/11353174')
  chapter1.raw_html = test_raw_html_from('misfits1')
  chapter2 = Chapter.create!(title: 'temp', parent_id: work1.id, position: 2)
  chapter2.update!(url: 'https://archiveofourown.org/works/4945936/chapters/11369638')
  chapter2.raw_html = test_raw_html_from('misfits2')
  work1.rebuild_meta

  work2 = Single.create!(title: 'temp', parent_id: series.id, position: 2)
  work2.update!(url: 'https://archiveofourown.org/works/13765827')
  work2.raw_html = test_raw_html_from('misfits3')
  work2.rebuild_meta
end

Given(/^Mandalorian Zuko exists$/) do
  series = Series.create!(title: 'Mandalorian Zuko', url: 'https://archiveofourown.org/series/1820452')

  book1 = Book.create!(parent_id: series.id, position: 1, url: 'https://archiveofourown.org/works/25131619')
  chapter1 = create_local_page 'meeting', 'https://archiveofourown.org/works/25131619/chapters/60890896'
  book1.add_chapter chapter1.url

  single = create_local_page 'mandalorian', 'https://archiveofourown.org/works/25534093'
  series.add_part single.url

  series.rebuild_meta
end
