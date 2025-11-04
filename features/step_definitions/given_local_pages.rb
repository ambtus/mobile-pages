# frozen_string_literal: true

Given('an editable page exists') do
  create_local_page 'edit'
end

Given('an image only chapter') do
  create_local_page 'img', 'http://www.illuminations.nu/foxmonkey/fic/chasez/legal1.html'
end

Given('another image only chapter') do
  create_local_page 'img2', 'https://archiveofourown.org/works/845764/chapters/1775725'
end

Given(/^He Could Be A Zombie exists$/) do
  create_local_page 'part6', 'https://www.fanfiction.net/s/5409165/6/It-s-For-a-Good-Cause-I-Swear'
end

Given(/^ibiki exists$/) do
  create_local_page 'ibiki', 'https://www.fanfiction.net/s/6783401/1/Ibiki-s-Apprentice'
end

Given(/^skipping exists$/) do
  create_local_page 'counting1', 'https://www.fanfiction.net/s/5853866/1'
end

Given(/^the flower exists$/) do
  create_local_page 'counting2', 'https://www.fanfiction.net/s/5853866/2'
end

Given('Death on the Nile exists') do
  create_local_page 'death', 'https://en.wikipedia.org/wiki/Death_on_the_Nile'
end

Given('Death in the Clouds exists') do
  create_local_page 'clouds', 'https://en.wikipedia.org/wiki/Death_in_the_Clouds'
end

Given('Dumb Witness exists') do
  create_local_page 'dumb', 'https://en.wikipedia.org/wiki/Dumb_Witness'
end

Given('Murder in the Mews exists') do
  create_local_page 'mews', 'https://en.wikipedia.org/wiki/Murder_in_the_Mews'
end
Given('Early Cases exists') do
  create_local_page 'early', "https://en.wikipedia.org/wiki/Poirot's_Early_Cases"
end

Given('Announced exists') do
  create_local_page 'announced', 'https://en.wikipedia.org/wiki/A_Murder_Is_Announced'
end

Given('The Awakening exists') do
  chapter1 = create_local_page 'ta1', 'https://keiramarcos.com/2009/03/the-awakening-part-one-five/'
  chapter2 = create_local_page 'ta2', 'https://keiramarcos.com/2009/03/the-awakening-part-six-ten/'
  book = create_local_page 'ta_nav', 'https://keiramarcos.com/fan-fiction/the-awakening/'
  book.add_chapter chapter1.url
  book.add_chapter chapter2.url
  book.rebuild_meta
end
