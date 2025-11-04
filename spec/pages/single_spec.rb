# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Single, type: :model do
  describe 'i start out as a single' do
    before do
      create_local_page 'fire1', 'https://archiveofourown.org/works/26249209/chapters/63892810'
    end

    it 'creates a single' do
      expect(described_class.count).to be 1
    end

    it 'does not gives me the default title' do
      expect(described_class.first.title).not_to eq 'xyzzy'
    end

    it 'does not gives me the chapter title' do
      expect(described_class.first.title).not_to eq 'Chapter 1'
    end
  end

  describe 'making me into a chapter of a new book' do
    before do
      create_local_page 'where', 'https://archiveofourown.org/works/692'
      described_class.first.make_me_into_a_chapter 'https://archiveofourown.org/works/692/chapters/803'
    end

    it 'creates a book' do
      expect(Book.count).to be 1
    end

    it 'makes me a chapter' do
      expect(Chapter.count).to be 1
    end

    it 'makes me the first chapter' do
      expect(Chapter.first.position).to be 1
    end

    it 'makes me a part' do
      expect(Book.first.parts.first).to eq Chapter.first
    end
  end

  describe 'making me into a chapter when I was in a series' do
    before do
      create_local_page 'where', 'https://archiveofourown.org/works/692'
      series = Series.create!(title: 'temp')
      series.add_part 'https://archiveofourown.org/works/692'
      described_class.first.make_me_into_a_chapter 'https://archiveofourown.org/works/692/chapters/803'
    end

    it 'becomes a chapter' do
      expect(Page.first.class).to be Chapter
    end

    it 'of a new book' do
      expect(Book.first.url).to eq 'https://archiveofourown.org/works/692'
    end

    it 'whose grandparent is the original series' do
      expect(Chapter.first.parent.parent).to eq Series.first
    end
  end
end
