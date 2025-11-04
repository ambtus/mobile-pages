# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'add_chapter' do
    it 'doesnt change the original chapter position' do
      create_book
      described_class.first.add_part(Chapter.second.url)

      expect(Chapter.second.position).to be 2
    end

    it 'can find parts from navigation html' do
      create_book

      expect(described_class.first.parts.count).to be 2
    end

    it 'does create a new chapter even if no html' do
      update_partial_book

      expect(described_class.first.parts.count).to be 2
    end

    it 'does reset the chapter title' do
      chapter1 = create_local_page 'fire1', 'https://archiveofourown.org/works/26249209/chapters/63892810'

      book = described_class.create!(title: 'new book')

      book.add_chapter(chapter1.url)
      expect(Chapter.first.title).to eq 'xyzzy'
    end
  end

  describe 'fetch_ao3' do
    it 'has navigate file' do
      create_book

      expect(File.exist?(described_class.first.navigate_html_file_name)).to be true
    end

    it 'but not a raw file' do
      create_book

      expect(File.exist?(described_class.first.raw_html_file_name)).to be false
    end

    it 'sets meta' do
      create_book

      expect(described_class.first.notes).to match 'by Sidra'
    end

    it 'updates from parts' do
      create_book

      expect(described_class.first.wordcount).to be 1581
    end

    it 'makes me a chapter' do
      create_book

      expect(described_class.first.parts.first.class).to be Chapter
    end

    it 'makes me a single' do
      create_single_chapter_book

      expect(Page.first.class).to be Single
    end
  end
end
