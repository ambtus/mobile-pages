# frozen_string_literal: true

Given(/^stuck exists$/) do
  book = Book.create!(base_url: 'http://www.fanfiction.net/s/2652996/*', url_substitutions: '1')
  fake_initial_fetch(book)
  copy_raw_from 'stuck1', book.parts.first
  book.rebuild_meta
end

Given(/^counting exists$/) do
  book = Page.create!(base_url: 'https://www.fanfiction.net/s/5853866/*', url_substitutions: '1-2')
  fake_initial_fetch(book)
  copy_raw_from 'counting1', book.parts.first
  copy_raw_from 'counting2', book.parts.second
  book.rebuild_meta
end

Given('Child of Four exists') do
  book = Book.create!(base_url: 'http://www.fanfiction.net/s/2790804/*', url_substitutions: '1-78')
  fake_initial_fetch(book)
  copy_raw_from 'intro', book.parts.first
  copy_raw_from 'first', book.parts.third
  copy_raw_from '78', book.parts.last
  book.rebuild_meta

  book.parts.first.update title: 'Introduction', notes: 'This story takes place in an Alternate Universe'
  book.parts.third.update title: 'First Year'
end

Given('part {int} exists') do |int|
  add_itl_part(int)
end
