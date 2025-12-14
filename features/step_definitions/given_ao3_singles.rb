# frozen_string_literal: true

Given(/^Where am I exists$/) do
  create_first_chapter
end

Given(/^Where am I existed and was read$/) do
  page = create_local_page 'where', 'https://archiveofourown.org/works/692'
  page.rate_today(5)
end

Given(/^Fuuinjutsu exists$/) do
  create_local_page 'Fuuinjutsu', 'https://archiveofourown.org/works/36425557'
end

Given(/^I Drive Myself Crazy exists$/) do
  create_single_chapter_book
end

Given(/^I Drive Myself Crazy existed$/) do
  create_local_page 'drive', 'https://archiveofourown.org/works/68481'
end

Given(/^Bad Formatting exists$/) do
  create_local_page 'notes', 'https://archiveofourown.org/works/23477578'
end

Given(/^Quoted Notes exists$/) do
  create_local_page 'quotes',  'https://archiveofourown.org/works/22989676/chapters/54962869'
end

Given(/^Multi Authors exists$/) do
  create_multi_authors
end

Given(/^Skipping Stones exists$/) do
  create_first_single
end

Given(/^Yer a Wizard exists$/) do
  create_yer_a_wizard
end

Given(/^The Picture exists$/) do
  create_local_page 'picture', 'https://archiveofourown.org/works/9381749/chapters/21239633'
end

Given(/^Prologue exists$/) do
  create_local_page 'prologue', 'https://archiveofourown.org/works/7755808/chapters/17685394'
end

Given('Wheel exists') do
  create_local_page 'wheel', 'https://archiveofourown.org/works/1115355'
end

Given('The Right Path exists') do
  create_local_page 'right', 'http://archiveofourown.org/works/5571483'
end

Given('had a heart exists') do
  create_local_page 'heart', 'https://archiveofourown.org/works/18246218'
end

Given('bananas exists') do
  create_local_page 'bananas', 'https://archiveofourown.org/works/1704596/chapters/3628919'
end

Given('salt water exists') do
  create_local_page 'salt', 'https://archiveofourown.org/works/1287505/chapters/6901151'
end

Given('paint exists') do
  create_local_page 'paint', 'https://archiveofourown.org/works/3410369'
end

Given('adapting exists') do
  create_local_page 'adapting', 'https://archiveofourown.org/works/6537379'
end

Given('fidelitas exists') do
  create_local_page 'fidelitas', 'https://archiveofourown.org/works/23881399'
end

Given('that was single exists') do
  create_local_page 'that', 'https://archiveofourown.org/works/38244064'
end

Given('guardian exists') do
  create_local_page 'guardian', 'https://archiveofourown.org/works/27953759/chapters/99977028'
end

Given('55367 exists') do
  create_local_page '55367', 'https://archiveofourown.org/works/5368520/chapters/12398933'
end

Given('not a chance exists') do
  create_local_page 'nota', 'https://archiveofourown.org/works/22529866'
end

Given('I asked exists') do
  create_local_page 'asked', 'https://archiveofourown.org/works/42267606/chapters/106131021'
end

Given('To Tame a Sorcerer exists') do
  create_local_page 'to_tame', 'https://archiveofourown.org/works/51369982'
end

Given('five times exists') do
  create_local_page 'five_times', 'https://archiveofourown.org/works/31918816'
end
