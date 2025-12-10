# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'fandom and author in notes' do
    it 'books can have both' do
      create_time_book

      expect(Book.first.short_notes).to match 'by Sidra; Harry Potter'
    end

    it 'singles can have both' do
      create_first_single
      expect(Single.first.short_notes).to match 'by Sidra; Harry Potter'
    end

    it 'chapters can have neither' do
      create_time_book

      expect(Chapter.first.short_notes).not_to match 'by Sidra; Harry Potter'
    end

    it 'series can have neither' do
      create_series

      expect(Series.first.short_notes).not_to match 'by Sidra; Harry Potter'
    end
  end

  describe 'set fandom and author by id' do
    it 'books can have both' do
      book = local_page(type: Book)
      book.set_tags_from_ids([fandom.id, author.id])

      expect(book.tag_cache).to eq 'Harry Potter, Sidra'
    end

    it 'singles can have both' do
      single = local_page(type: Single)
      single.set_tags_from_ids([fandom.id, author.id])

      expect(single.tag_cache).to eq 'Harry Potter, Sidra'
    end

    it 'chapters can have neither' do
      chapter = local_page(type: Chapter)
      chapter.set_tags_from_ids([fandom.id, author.id])

      expect(chapter.tag_cache).to eq ''
    end

    it 'series can have neither' do
      series = local_page(type: Series)
      series.set_tags_from_ids([fandom.id, author.id])

      expect(series.tag_cache).to eq ''
    end
  end

  describe 'set fandom by name' do
    it 'books can have fandom' do
      book = local_page(type: Book)
      book.add_tags_from_string('Harry Potter', 'Fandom')

      expect(book.tag_cache).to eq 'Harry Potter'
    end

    it 'singles can have fandom' do
      single = local_page(type: Single)
      single.add_tags_from_string('Harry Potter', 'Fandom')
      expect(single.tag_cache).to eq 'Harry Potter'
    end

    it 'chapters cannot' do
      chapter = local_page(type: Chapter)
      chapter.add_tags_from_string('Harry Potter', 'Fandom')
      expect(chapter.tag_cache).to eq ''
    end

    it 'series cannot' do
      series = local_page(type: Series)
      series.add_tags_from_string('Harry Potter', 'Fandom')
      expect(series.tag_cache).to eq ''
    end
  end

  it 'chapter inherits tags when downloaded' do
    create_time_book
    Book.first.add_tags_from_string('Harry Potter', 'Fandom')

    expect(Chapter.first.download_tag_string).to match 'Harry Potter'
  end

  it 'series inherits tags when downloaded' do
    create_series
    Single.first.add_tags_from_string('Harry Potter', 'Fandom')

    expect(Series.first.download_tag_string).to match 'Harry Potter'
  end
end
