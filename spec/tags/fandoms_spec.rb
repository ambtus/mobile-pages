# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fandom, type: :class do
  it 'is a type of tag' do
    described_class.create(name: 'testing')

    expect(Tag.first.class).to be described_class
  end

  describe 'multiple fandoms' do
    it 'all can be in the notes' do
      create_multi_fandoms

      expect(Page.first.notes).to match '<p>Harry Potter, Die Hard, Robin Hood</p>'
    end

    it 'two can be in the notes' do
      described_class.create!(name: 'Harry Potter')
      create_multi_fandoms

      expect(Page.first.notes).to match '<p>Die Hard, Robin Hood</p>'
    end

    it 'drops the part after dash' do
      create_multi_fandoms

      expect(Page.first.notes).not_to match 'Rowling'
    end

    it 'drops the part in parenthesise' do
      create_multi_fandoms

      expect(Page.first.notes).not_to match 'Movies'
    end

    it 'drops the part after colon' do
      create_multi_fandoms

      expect(Page.first.notes).not_to match 'Prince of Thieves (1991)'
    end

    describe 'and one in the tags' do
      it 'find by fandom' do
        a = described_class.create!(name: 'Harry Potter')
        create_multi_fandoms

        expect(Page.first.tags).to include a
      end

      it 'find by pseud of fandom' do
        a = described_class.create!(name: 'JKR (Harry Potter)')
        create_multi_fandoms
        expect(Page.first.tags).to include a
      end

      it 'find when lower case' do
        a = described_class.create!(name: 'harry potter')
        create_multi_fandoms
        expect(Page.first.tags).to include a
      end
    end
  end

  describe 'matching fandoms' do
    it 'all can be in the notes' do
      create_yer_a_wizard

      expect(Page.first.notes).to match '<p>Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series</p>'
    end

    it 'does not overmatch the word of' do
      a = described_class.create!(name: 'Person of Interest')
      create_yer_a_wizard
      expect(Page.first.tags).not_to include a
    end

    it 'does match a substring' do
      a = described_class.create!(name: 'Drizzt')
      create_yer_a_wizard
      expect(Page.first.tags).to include a
    end

    it 'does match a substring in aka' do
      a = described_class.create!(name: 'Forgotten Realms (Drizzt)')
      create_yer_a_wizard
      expect(Page.first.tags).to include a
    end

    it 'does match two at a time' do
      described_class.create!(name: 'Forgotten Realms (Drizzt)')
      create_yer_a_wizard
      expect(Page.first.notes).to match '<p>Starlight and Shadows Series</p>'
    end
  end
end
