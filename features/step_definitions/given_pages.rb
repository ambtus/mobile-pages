# frozen_string_literal: true

Given(/a page exists with (.*)/) do |fields|
  hash = create_hash(fields)
  create_from_hash(hash)
end

Given('a page exists') do
  Page.create(title: 'Page 1')
end

Given('{int} pages exist') do |count|
  count.times do |i|
    Page.create(title: "Page #{i + 1}", read_after: "2000-01-#{i + 1}")
    Kernel.sleep 1 if i < 1 # sorting on created by for 2 pages
  end
end

# create one or more different pages
Given(/^the following pages?$/) do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    hash['urls'] = hash['urls'].split(',').join("\r") if hash['urls']
    create_from_hash(hash.symbolize_keys)
  end
end

Given('a test page exists') do
  Single.create(title: 'Test', url: 'http://test.sidrasue.com/short.html')
end

Given('system down exists') do
  page = Page.create!(url: 'http://test.sidrasue.com/test.html', title: 'Test')
  page.raw_html = 'system down'
end

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

Given('a Single exists') do
  Single.create!(title: 'Single')
end

Given('I have a Single with title {string} and url {string}') do |title, url|
  Single.create!(title: title, url: url)
end

Given('the single has a parent') do
  page = Single.first
  Series.create(title: 'Parent')
  page.add_parent('Parent')
end

Given('a short book exists') do
  book = Book.create!(title: 'Book')
  2.times do |i|
    Chapter.create(title: "Chapter #{i + 1}", parent_id: book.id, position: i + 1)
  end
end

Given('a long book exists') do
  book = Book.create!(title: 'Book')
  6.times do |i|
    Chapter.create!(title: "chapter #{i + 1}", parent_id: book.id, position: i + 1)
  end
  book.update_from_parts
end

Given('a long partially read book exists') do
  book = Book.create(title: 'Book')
  10.times { |i| Chapter.create!(title: "Part #{i + 1}", parent_id: book.id, position: i + 1, url: "https://www.fanfiction.net/s/7347955/#{i + 1}/Dreaming-of-Sunshine", last_read: '2009-01-01', stars: 4) }
  10.times { |i| Chapter.create!(title: "Part #{i + 11}", parent_id: book.id, position: i + 11, url: "https://www.fanfiction.net/s/7347955/#{i + 11}/Dreaming-of-Sunshine") }
  book.update_from_parts
end

Given('a series exists') do
  series = Series.create!(title: 'Series')
  book1 = Book.create!(title: 'Book1', parent_id: series.id, position: 1)
  Chapter.create!(title: 'Prologue', parent_id: book1.id, position: 1, url: 'http://test.sidrasue.com/parts/1.html')
  Chapter.create!(title: 'Cliffhanger', parent_id: book1.id, position: 2, url: 'http://test.sidrasue.com/parts/2.html')
  book2 = Book.create!(title: 'Another Book', parent_id: series.id, position: 2)
  Chapter.create!(title: 'Season2', parent_id: book2.id, position: 1, url: 'http://test.sidrasue.com/parts/3.html')
  Chapter.create!(title: 'Epilogue', parent_id: book2.id, position: 2, url: 'http://test.sidrasue.com/parts/4.html')
  Single.create!(title: 'Extras', parent_id: series.id, position: 3, url: 'http://test.sidrasue.com/parts/5.html')
end

Given('I have a series with read_after {string}') do |string|
  series = Series.create!(title: 'Grandparent', read_after: string, last_read: string.to_date - 1.year, stars: 4)
  Single.create!(title: 'Parent1', parent_id: series.id, position: 1, read_after: string,
last_read: string.to_date - 1.year, stars: 4)
  parent2 = Book.create!(title: 'Parent2', parent_id: series.id, position: 2, read_after: string,
last_read: string.to_date - 1.year, stars: 4)
  Chapter.create!(title: 'Subpart', parent_id: parent2.id, position: 1, read_after: string,
last_read: string.to_date - 1.year, stars: 4)
end

Given('Uneven exists') do
  parent = Book.create!(title: 'Uneven')
  4.times do |i|
    int = i + 1
    Chapter.create(title: "part #{int}", parent_id: parent.id, position: int, last_read: "2010-01-0#{int}",
stars: int).update_read_after
  end
  Chapter.create(title: 'part 5', parent_id: parent.id, position: 5)
  parent.update_from_parts
end

Given('a partially read page exists') do
  book3 = Book.create(title: 'Book')
  Chapter.create(title: 'Read', parent_id: book3.id, position: 1).rate_today(5)
  Chapter.create(title: 'Unread', parent_id: book3.id, position: 2)
  book3.update_from_parts
end

Given('a read page exists') do
  Single.create(title: 'Page 1').rate_today(5)
end

Given('favorite exists') do
  Single.create!(title: 'Mirror of Maybe', favorite: true)
end
Given('a work exists with chapter end_notes') do
  book = Book.create(title: 'Book')
  ch1 = Chapter.create(title: 'ch1', parent_id: book.id, position: 1, end_notes: 'chapter 1 end notes')
  ch1.raw_html = '<head><title>Test</title></head><body><p>Retrieved from the web 1</p></body>'
  ch2 = Chapter.create(title: 'ch2', parent_id: book.id, position: 2, end_notes: 'chapter 2 end notes', url: 'http://test.sidrasue.com/test2.html')
  ch2.raw_html = '<head><title>Test</title></head><body><p>Retrieved from the web 2</p></body>'
  book.update_from_parts
end

Given('a work exists with chapter end_notes at end') do
  book = Book.create(title: 'Book')
  ch1 = Chapter.create(title: 'ch1', parent_id: book.id, position: 1, end_notes: 'chapter 1 end notes', at_end: true)
  ch1.raw_html = '<head><title>Test</title></head><body><p>Retrieved from the web 1</p></body>'
  ch2 = Chapter.create(title: 'ch2', parent_id: book.id, position: 2, end_notes: 'chapter 2 end notes', at_end: true)
  ch2.raw_html = '<head><title>Test</title></head><body><p>Retrieved from the web 2</p></body>'
  ch3 = Chapter.create(title: 'ch3', parent_id: book.id, position: 3, at_end: true)
  ch3.raw_html = '<head><title>Test</title></head><body><p>Retrieved from the web 3</p></body>'

  book.update_from_parts
end

Given('a work exists with chapter and work notes') do
  book = Book.create(title: 'Book', notes: 'work notes')
  ch1 = Chapter.create(title: 'ch1', parent_id: book.id, position: 1, notes: 'ch1 notes')
  ch1.raw_html = '<head><title>Test</title></head><body><p>Retrieved from the web 1</p></body>'

  ch2 = Chapter.create(title: 'ch2', parent_id: book.id, position: 2, notes: 'ch2 notes', url: 'http://test.sidrasue.com/test2.html')
  ch2.raw_html = '<head><title>Test</title></head><body><p>Retrieved from the web 2</p></body>'

  book.update_from_parts
end

Given('I have a partially read series') do
  series = Series.create!(title: 'Grandparent')
  Single.create!(title: 'Parent1', parent_id: series.id, position: 1).rate_today(4)
  parent2 = Book.create!(title: 'Parent2', parent_id: series.id, position: 2)
  Chapter.create!(title: 'Subpart1', parent_id: parent2.id, position: 1)
  Chapter.create!(title: 'Subpart2', parent_id: parent2.id, position: 2).rate_today(3)
end

Given('three singles exist') do
  3.times do |i|
    Single.create(title: "Parent#{i + 1}")
  end
end

Given('I have Books with titles {string} and {string}') do |title1, title2|
  create_from_hash(title: title1, base_url: 'http://test.sidrasue.com/parts/*.html', url_substitutions: '1-2')
  create_from_hash(title: title2, base_url: 'http://test.sidrasue.com/parts/*.html', url_substitutions: '4-6')
end

Given('a partially read book exists') do
  book = Book.create!(title: 'Book')
  6.times do |i|
    Chapter.create!(title: "chapter #{i + 1}", parent_id: book.id, position: i + 1)
  end
  chapter1 = book.parts.first
  chapter1.update last_read: '2009-01-01', stars: 4
  chapter1.update_read_after
  chapter2 = book.parts.second
  chapter2.update last_read: '2010-01-01', stars: 2
  chapter2.update_read_after
  book.update_from_parts
end

Given('a book with a tagged chapter exists') do
  book = Book.create!(title: 'Book')
  pro = Pro.find_or_create_by(name: 'interesting')
  chapter = Chapter.create!(title: 'chapter 1', parent_id: book.id, position: 1)
  chapter.tags << pro
  chapter.update_tag_caches
  book.update_from_parts
end

Given('pages with all possible wips exist') do
  wipb = Book.create!(title: 'wip book', wip: true)
  2.times do |i|
    Chapter.create(title: "Chapter #{i + 1}", parent_id: wipb.id, position: i + 1)
  end
  finb = Book.create(title: 'finished book')
  2.times do |i|
    Chapter.create(title: "Chapter #{i + 1}", parent_id: finb.id, position: i + 1)
  end
  wips = Series.create!(title: 'wip series', wip: true)
  2.times do |i|
    Book.create!(title: "Book #{i + 1}", parent_id: wips.id, position: i + 1)
  end
  fins = Series.create!(title: 'finished series')
  2.times do |i|
    Book.create!(title: "Book #{i + 1}", parent_id: fins.id, position: i + 1)
  end
  finswipb = Series.create!(title: 'finished series with wip book')
  2.times do |i|
    Book.create!(title: "#{'wip ' if i == 1}book#{i + 1}", parent_id: finswipb.id, position: i + 1, wip: i == 1)
  end
  wipswipb = Series.create!(title: 'wip series with wip book', wip: true)
  2.times do |i|
    Book.create!(title: "#{'wip ' if i.zero?}book#{i + 1}", parent_id: wipswipb.id, position: i + 1, wip: i.zero?)
  end
end

Given('pages with all combinations of pros and cons exist') do
  interesting = Pro.find_or_create_by(name: 'interesting')
  boring = Con.find_or_create_by(name: 'boring')
  loving = Pro.find_or_create_by(name: 'loving')
  hateful = Con.find_or_create_by(name: 'hateful')
  Page.find_or_create_by(title: 'page1').tags << [hateful, boring]
  Page.find_or_create_by(title: 'page2h').tags << hateful
  Page.find_or_create_by(title: 'page2b').tags << boring
  Page.find_or_create_by(title: 'page3d')
  Page.find_or_create_by(title: 'page3l').tags << [boring, loving]
  Page.find_or_create_by(title: 'page3h').tags << [hateful, interesting]
  Page.find_or_create_by(title: 'page4l').tags << loving
  Page.find_or_create_by(title: 'page4i').tags << interesting
  Page.find_or_create_by(title: 'page5').tags << [interesting, loving]
  Page.all.map(&:update_tag_caches)
end

Given('pages with all possible favorites exist') do
  Single.create(title: 'good single', favorite: true)
  Single.create(title: 'bad single')
  Kernel.sleep 1
  book = Book.create!(title: 'bad parent of good child')
  Chapter.create!(title: 'good child', parent_id: book.id, position: 1, favorite: true)
  Kernel.sleep 1
  book = Book.create!(title: 'bad parent of bad child')
  Chapter.create!(title: 'bad child', parent_id: book.id, position: 1)
  Kernel.sleep 1
  book = Book.create!(title: 'good parent of good child', favorite: true)
  Chapter.create!(title: 'good child', parent_id: book.id, position: 1, favorite: true)
  Kernel.sleep 1
  book = Book.create!(title: 'good parent of bad child', favorite: true)
  Chapter.create!(title: 'bad child', parent_id: book.id, position: 1)
end

Given('pages with all combinations of pros and cons and readers and hiddens exist') do
  pro = Pro.find_or_create_by(name: 'interesting')
  con = Con.find_or_create_by(name: 'boring')
  reader = Reader.find_or_create_by(name: 'Sidra')
  hidden = Hidden.find_or_create_by(name: 'hide me')
  Page.find_or_create_by(title: 'pagehc').tags << [hidden, con]
  Page.find_or_create_by(title: 'pageh').tags << hidden
  Page.find_or_create_by(title: 'pagec').tags << con
  Page.find_or_create_by(title: 'untagged')
  Page.find_or_create_by(title: 'pagecr').tags << [con, reader]
  Page.find_or_create_by(title: 'pagehp').tags << [hidden, pro]
  Page.find_or_create_by(title: 'pager').tags << reader
  Page.find_or_create_by(title: 'pagep').tags << pro
  Page.find_or_create_by(title: 'pagepr').tags << [pro, reader]
  Page.all.map(&:update_tag_caches)
end

Given('pages with all possible soons exist') do
  Page.create(title: 'now reading', soon: 0)
  Page.create(title: 'read next', soon: 1)
  Page.create(title: 'read sooner', soon: 2)
  Page.create(title: 'default', soon: 3)
  Page.create(title: 'read later', soon: 4)
end

Given('pages with all possible unreads exist') do
  Single.create(title: 'not read single')
  Book.create(title: 'not read book')
  Series.create(title: 'not read series')
  Single.create(title: 'yes read single', last_read: 1.day.ago)
  Book.create(title: 'yes read book', last_read: 2.days.ago)
  Series.create(title: 'yes read series', last_read: 3.days.ago)
  prb = Book.create!(title: 'partially read book')
  2.times do |i|
    Chapter.create!(title: "Part #{i + 1}", parent_id: prb.id, position: i + 1, last_read: (Time.zone.today if i.zero?))
  end
  prb.update_from_parts
  prs = Series.create!(title: 'partially read series')
  2.times do |i|
    Book.create!(title: "Book #{i + 1}", parent_id: prs.id, position: i + 1, last_read: (Time.zone.today if i.zero?))
  end
  prs.update_from_parts
end

Given('six pages and two hidden pages downloaded') do
  6.times do |i|
    Single.create(title: "reading #{i + 1}")
  end
  2.times do |i|
    Single.create(title: "hidden #{i + 1}").add_tags_from_string('hide me', 'Hidden')
  end
  Page.find_each do |page|
    visit page_path(page)
    within('.views') { click_link('ePub') }
  end
end

Given('eleven downloaded pages exist') do
  11.times do |i|
    Single.create(title: "reading #{i + 1}", soon: 0)
  end
end

Given('pages with all possible sizes exist') do
  Page.create(title: 'Drabble').raw_html = drabble
  Page.create(title: 'Short').raw_html = short
  Page.create(title: 'Medium').raw_html = medium
  Page.create(title: 'Long').raw_html = long
  Page.create(title: 'Epic').raw_html = epic
  book = Book.create(title: 'DrabbleBook')
  3.times do |i|
    Chapter.create(title: "Chapter #{i + 1}", parent_id: book.id, position: i + 1).raw_html = drabble
  end
  book.update_from_parts
  book = Book.create(title: 'ShortBook')
  9.times do |i|
    Chapter.create(title: "Chapter #{i + 1}", parent_id: book.id, position: i + 1).raw_html = drabble
  end
  book.update_from_parts
  book = Book.create(title: 'MediumBook')
  9.times do |i|
    Chapter.create(title: "Chapter #{i + 1}", parent_id: book.id, position: i + 1).raw_html = short
  end
  book.update_from_parts
  book = Book.create(title: 'LongBook')
  9.times do |i|
    Chapter.create(title: "Chapter #{i + 1}", parent_id: book.id, position: i + 1).raw_html = medium
  end
  book.update_from_parts
  book = Book.create(title: 'EpicBook')
  9.times do |i|
    Chapter.create(title: "Chapter #{i + 1}", parent_id: book.id, position: i + 1).raw_html = long
  end
  book.update_from_parts
end

Given('pages with all possible stars exist') do
  Page.create(title: 'page4').rate_today(4)
  Page.create(title: 'page0')
  Page.create(title: 'page3').rate_today(3)
  Page.create(title: 'page5').rate_today(5)
end

Given('the second had been made read first') do
  page = Page.second
  page.update read_after: page.read_after - 1.year
end

Given('three re-entry works exist') do
  Single.create(title: 'delayed re-entry')
  Single.create(title: 'Re-Entry')
  Single.create(title: 'Re-Entry: Journey of the Whills')
end

Given('pages with all possible types exist') do
  Single.create(title: 'One-shot', url: 'http://test.sidrasue.com/short.html')
  create_from_hash(title: 'Novel', base_url: 'http://test.sidrasue.com/long*.html', url_substitutions: '1-2')
  series = Series.create!(title: 'Trilogy')
  book1 = create_from_hash(title: 'Alpha', parent_id: series.id, position: 1, urls: 'http://test.sidrasue.com/parts/1.html')
  book1.parts.first.update(title: 'Prologue')
  book2 = create_from_hash(title: 'Beta', parent_id: series.id, position: 2, urls: 'http://test.sidrasue.com/parts/5.html')
  book2.parts.last.update(title: 'Epilogue')

  # it's a bug, but it's happened before
  untyped = Page.create!(title: 'Untyped')
  untyped.update!(type: nil)
end
