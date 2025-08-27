# frozen_string_literal: true

def partial_book
  page = Book.create!(title: 'temp')
  page.update!(url: 'https://archiveofourown.org/works/692')
  chapter1 = Chapter.create!(title: 'temp', parent_id: page.id, position: 1)
  chapter1.update!(url: 'https://archiveofourown.org/works/692/chapters/803')
  chapter1.set_raw_from('where').rate_today('3')
  page.rebuild_meta
  page.update_from_parts
end

def first_chapter
  Book.first.parts.first
end

def singles
  Single.create(title: 'not read single')
  Single.create(title: 'yes read single').rate_today(5)
end

def books
  book1 = Book.create(title: 'not read book')
  Chapter.create(title: 'not read chapter', parent_id: book1.id)
  book1.update_from_parts

  book2 = Book.create(title: 'yes read book')
  Chapter.create(title: 'yes read chapter', parent_id: book2.id).rate_today(5)
  book2.update_from_parts

  book3 = Book.create(title: 'partially read book')
  Chapter.create(title: 'not read chapter', parent_id: book3.id)
  Chapter.create(title: 'yes read chapter', parent_id: book3.id).rate_today(5)
  book3.update_from_parts
end

def series
  series1 = Series.create(title: 'not read series')
  book4 = Book.create(title: 'another not read book', parent_id: series1.id)
  Chapter.create(title: 'another not read chapter', parent_id: book4.id)
  book4.update_from_parts
  series1.update_from_parts

  series2 = Series.create(title: 'partially read series')
  book5 = Book.create(title: 'another partially read book', parent_id: series2.id)
  Chapter.create(title: 'yet another not read chapter', parent_id: book5.id)
  Chapter.create(title: 'another read chapter', parent_id: book5.id).rate_today(5)
  book5.update_from_parts
  series2.update_from_parts

  series3 = Series.create(title: 'yes read series')
  book6 = Book.create(title: 'another read book', parent_id: series3.id)
  Chapter.create(title: 'another read chapter', parent_id: book6.id).rate_today(5)
  book6.update_from_parts
  series3.update_from_parts
end
