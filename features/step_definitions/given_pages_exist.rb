Given("{int} pages exist") do |count|
  count.times do |i|
    Page.create(title: "Page #{(i+1)}", read_after: "2000-01-#{i+1}")
    Kernel::sleep 1 if i<1  # sorting on created by for 2 page
  end
end

Given('{int} pages with cons: {string} exist') do |count, string|
  con = Con.find_or_create_by(name: string)
  count.times do |i|
    con.pages << Page.create(title: "Page #{(i+1)}", read_after: "2000-01-#{i+1}")
  end
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

Given("pages with all possible sizes exist") do
  Page.create(title: "Medium", url: "file:///#{Rails.root}/features/html/long.html")
  Page.create(title: "Drabble").raw_html=100.times.collect{|i| (i+1).to_s}.join(" ")
  Page.create(title: "Long2", base_url: "file:///#{Rails.root}/features/html/long*.html", url_substitutions: "1-9")
  Page.create(title: "Short", url: "file:///#{Rails.root}/features/html/short.html")
  Page.create(title: "Long", url: "file:///#{Rails.root}/features/html/40000.html")
  Page.create(title: "Epic", base_url: "file:///#{Rails.root}/features/html/epic*.html", url_substitutions: "1-9")
  Page.create(title: "Medium2", base_url: "file:///#{Rails.root}/features/html/medium*.html", url_substitutions: "1-5")
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

Given("pages with pros and cons exist") do
  Page.delete_all
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
end

Given('Uneven exists') do
  parent = Book.create!(title: "Uneven")
  4.times do |i|
    int = i + 1
    part = Chapter.create(title: "part #{int}", parent_id: parent.id, position: int, last_read: "2010-01-0#{int}", stars: int).update_read_after
  end
  Chapter.create(title: "part 5", parent_id: parent.id, position: 5)
  parent.update_from_parts
end

Given('link in notes exists') do
  page = Single.create!(title: "Silent Sobs")
  page.notes = File.open(Rails.root + "features/html/silent.html", 'r:utf-8') { |f| f.read }
  page.save!
end

Given('a page with very long notes exists') do
  string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "*10
  Page.create(title: "Page 1", notes: string)
end

Given('system down exists') do
  page = Page.create!(url: "http://test.sidrasue.com/test.html", title: "Test")
  page.raw_html = "system down"
end

Given /^He Could Be A Zombie exists$/ do
  page = Single.create!(url: "https://www.fanfiction.net/s/5409165/6/It-s-For-a-Good-Cause-I-Swear")
  page.set_raw_from("part6")
end

Given /^stuck exists$/ do
  page = Book.create!(base_url: "https://www.fanfiction.net/s/2652996/*", url_substitutions: "1")
  page.parts.first.set_raw_from("stuck1")
  page.rebuild_meta.set_wordcount(false)
end

Given /^ibiki exists$/ do
  page = Single.create!(url: "https://www.fanfiction.net/s/6783401/1/Ibiki-s-Apprentice")
  page.set_raw_from("ibiki")
end

Given /^skipping exists$/ do
  page = Single.create!(url: "https://www.fanfiction.net/s/5853866/1/Counting")
  page.set_raw_from("counting1")
end

Given /^counting exists$/ do
  page = Book.create!(base_url: "https://www.fanfiction.net/s/5853866/*", url_substitutions: "1-2")
  page.parts.first.set_raw_from("counting1")
  page.parts.second.set_raw_from("counting2")
  page.rebuild_meta.set_wordcount(false)
end

Given("Child of Four exists") do
  page = Book.create!(base_url: "http://www.fanfiction.net/s/2790804/*", url_substitutions: "1-78")
  chapter1 = page.parts.first
  chapter1.update title: "Introduction", notes: "This story takes place in an Alternate Universe"
  chapter1.set_raw_from("intro")
  chapter3 = page.parts.third
  chapter3.update title: "First Year"
  chapter3.set_raw_from("first")
  page.parts.last.set_raw_from("78")
  page.rebuild_meta
end

Given /a page exists(?: with (.*))?/ do |fields|
  fields.blank? ? hash = {} : hash = fields.create_hash
  hash[:title] = hash[:title] || "Page 1"
  hash[:urls] =  hash[:urls].split(',').join("\r") if hash[:urls]
  Utilities.create_from_hash(hash)
end

# create one or more different pages
Given /^the following pages?$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    hash['urls'] =  hash['urls'].split(',').join("\r") if hash['urls']
    Utilities.create_from_hash(hash.symbolize_keys)
  end
end

