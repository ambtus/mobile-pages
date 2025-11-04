# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filter, type: :class do
  describe 'by tag' do
    before do
      Tag.create!(name: 'xyzzy').pages.create!(title: 'found')
      Tag.create!(name: 'plugh').pages.create!(title: 'lost')
    end

    it 'finds all by tag name' do
      expect(described_class.tag('xyzzy', 0).count).to be 1
    end

    it 'finds page by tag name' do
      expect(described_class.tag('xyzzy', 0).first.title).to eq 'found'
    end
  end

  describe 'new' do
    before { read_and_unread_pages }

    describe 'omits parts by default' do
      it 'can filter eight parents' do
        expect(Page.where(parent_id: nil).count).to be 8
      end

      it 'can find unread' do
        expect(described_class.new({ unread: 'Unread' }).count).to be 3
      end

      it 'can find parially unread' do
        expect(described_class.new({ unread: 'Parts' }).count).to be 2
      end

      it 'can find fully read' do
        expect(described_class.new({ unread: 'Read' }).count).to be 3
      end
    end

    describe 'can find parts if asked' do
      it 'can filter eight parents' do
        expect(Page.count).to be 19
      end

      it 'can find partially read' do
        expect(described_class.new({ unread: 'Parts', type: 'all' }).count).to be 3
      end
    end
  end

  describe 'all' do
    before { read_and_unread_pages }

    it 'can find unread' do
      expect(described_class.all({ unread: 'Unread', type: 'all' }).count).to be 8
    end

    it 'can find fully read' do
      expect(described_class.all({ unread: 'Read', type: 'all' }).count).to be 8
    end
  end
end
