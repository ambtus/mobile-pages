# frozen_string_literal: true

Given('a page with very long notes exists') do
  string = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' * 10
  Page.create(title: 'Page 1', notes: string)
end

Given('I have a book with read_after {string}') do |string|
  parent = Single.create!(title: 'Parent', read_after: string, last_read: string.to_date - 1.year, stars: 4)
  Chapter.create!(title: 'Part 1', parent_id: parent.id, position: 1, read_after: string,
last_read: string.to_date - 1.year, stars: 4)
end

Given('I have a single with read_after {string}') do |string|
  Single.create!(title: 'Single', read_after: string, last_read: string.to_date - 1.year, stars: 4)
end
