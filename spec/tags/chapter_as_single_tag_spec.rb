# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'chapter as single' do
    it 'does get fandom and author tags' do
      f = Fandom.create!(name: 'Star Wars')
      a = Author.create!(name: 'adiduck')

      create_multi_authors
      expect(Single.first.tags).to eq [a, f]
    end

    it 'but does not get special tags like fix-it' do
      create_multi_authors
      expect(Single.first.short_notes).not_to match 'Fix-It'
    end

    it 'or characters' do
      create_multi_authors
      expect(Single.first.short_notes).not_to match 'Jango'
    end
  end
end
