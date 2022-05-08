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
  page = Single.create!(url: "https://www.fanfiction.net/s/5853866/1")
  page.set_raw_from("counting1")
end

Given /^the flower exists$/ do
  page = Single.create!(url: "https://www.fanfiction.net/s/5853866/2")
  page.set_raw_from("counting2")
end

Given /^counting exists$/ do
  page = Book.create!(base_url: "https://www.fanfiction.net/s/5853866/*/Counting", url_substitutions: "1-2")
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

