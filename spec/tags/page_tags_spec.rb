# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageTags, type: :module do
  describe 'special tags are derived' do
    it 'like time travel' do
      create_fuuinjutsu
      expect(Page.first.tt_present?).to be true
    end

    it 'and fix it' do
      create_fuuinjutsu
      expect(Page.first.fi_present?).to be true
    end

    it 'but only when they exist in meta' do
      create_first_single
      expect(Page.first.tags.blank?).to be true
    end
  end

  it 'special tags are not derived from notes' do
    create_time_book
    expect(Book.first.tt_present?).to be false
  end

  it 'special tags can be added to books' do
    create_time_book.set_tt
    expect(Book.first.tt_present?).to be true
  end
end
