# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :class do
  it 'is a type of tag' do
    described_class.create(name: 'testing')

    expect(Tag.first.class).to be described_class
  end

  describe 'multiple authors' do
    it 'all can be in the notes' do
      create_multi_authors

      expect(Page.first.notes).to start_with '<p>by adiduck (book_people), whimsicalimages'
    end

    it 'one can be in the notes' do
      described_class.create!(name: 'adiduck (book_people)')
      create_multi_authors

      expect(Page.first.notes).to start_with '<p>et al: whimsicalimages'
    end

    describe 'and one in the tags' do
      it 'find by author with pseud' do
        a = described_class.create!(name: 'adiduck (book_people)')
        create_multi_authors

        expect(Page.first.tags).to include a
      end

      it 'find by pseud with author' do
        a = described_class.create!(name: 'book_people (adiduck)')
        create_multi_authors

        expect(Page.first.tags).to include a
      end

      it 'find by author only' do
        a = described_class.create!(name: 'adiduck')
        create_multi_authors

        expect(Page.first.tags).to include a
      end

      it 'find by pseud only' do
        a = described_class.create!(name: 'book_people')
        create_multi_authors

        expect(Page.first.tags).to include a
      end

      it 'find when capitalized' do
        a = described_class.create!(name: 'Adiduck')
        create_multi_authors

        expect(Page.first.tags).to include a
      end

      it 'find when lower case' do
        a = described_class.create!(name: 'sidra')
        create_first_single

        expect(Page.first.tags).to include a
      end
    end
  end
end
