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

Given /^I Drive Myself Crazy existed$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/68481")
  page.set_raw_from("drive")
end

Given /^I Drive Myself Crazy exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/68481")
  page.set_raw_from("drive_new")
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

Given /^Alan Rickman exists$/ do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/5720104")
  page.set_raw_from("alan")
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

Given('The Right Path exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "http://archiveofourown.org/works/5571483")
  page.set_raw_from("right")
end

Given('had a heart exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/18246218")
  page.set_raw_from("heart")
end

Given('bananas exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/1704596/chapters/3628919")
  page.set_raw_from("bananas")
end

Given('salt water exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/1287505/chapters/6901151")
  page.set_raw_from("salt")
end

Given('paint exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/3410369")
  page.set_raw_from("paint")
end

Given('adapting exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/6537379")
  page.set_raw_from("adapting")
end

Given('fidelitas exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/23881399")
  page.set_raw_from("fidelitas")
end

Given('that was single exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/38244064")
  page.set_raw_from("that")
end

Given('guardian exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/27953759/chapters/99977028")
  page.set_raw_from("guardian")
end

Given('55367 exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/5368520/chapters/12398933")
  page.set_raw_from("55367")
end

Given('not a chance exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/22529866")
  page.set_raw_from("nota")
end

Given('I asked exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/42267606/chapters/106131021")
  page.set_raw_from("asked")
end

Given('To Tame a Sorcerer exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://archiveofourown.org/works/51369982")
  page.set_raw_from("to_tame")
end
