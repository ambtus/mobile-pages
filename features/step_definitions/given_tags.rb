# frozen_string_literal: true

Given('{string} is a(n) {string}') do |string, string2|
  klass = string2.constantize
  klass.find_or_create_by(name: string)
end

Given('{int} pages with cons: {string} exist') do |count, string|
  con = Con.find_or_create_by(name: string)
  count.times do |i|
    con.pages << Page.create(title: "Page #{i + 1}", read_after: "2000-01-#{i + 1}")
    con.pages.map(&:update_tag_caches)
  end
end

Given('the tag {string} is destroyed without caching') do |string|
  tag = Tag.find_by(name: string)
  tag.destroy
end

Given('tags exist') do
  Fandom.find_or_create_by(name: 'Harry Potter')
  Fandom.find_or_create_by(name: 'Popslash')
  Author.find_or_create_by(name: 'Sidra')
  Author.find_or_create_by(name: 'esama')
end

Given('part {int} has reader {string}') do |int, string|
  part = Series.first.parts[int - 1]
  raise "part #{int} not found" unless part

  reader = Reader.find_or_create_by(name: string)
  part.tags << reader
  part.update_tag_caches
end
