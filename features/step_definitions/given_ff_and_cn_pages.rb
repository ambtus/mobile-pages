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

Given('Urgency exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/the-resolute-urgency-of-now-time-travel-trope-bingo-2020-2021/")
  page.set_raw_from("urgency")
end

Given('Time exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/time-after-time/")
  page.set_raw_from("time")
end

Given('Wish exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/bingo/i-wish-amnesia-trope-bingo-2020-2021/")
  page.set_raw_from("wish")
end

Given('Secret exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/the-secret-to-survivin/")
  page.set_raw_from("secret")
end

Given('Crazy exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/crazy-little-thing/")
  page.set_raw_from("crazy")
end

Given('Something exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/something-in-my-liberty/")
  page.set_raw_from("something")
end

Given('Art exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://clairesnook.com/fiction/almost-paradise-art-by-fashi0n/")
  page.set_raw_from("art")
end
