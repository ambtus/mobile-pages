# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageTitles, type: :module do
  before { create_open_book }

  describe 'chapter titles' do
    it 'can be boring' do
      expect(Chapter.first.title).to eq 'Chapter 1'
    end

    it 'or interesting' do
      expect(Chapter.second.title).to eq 'Ours'
    end
  end

  describe 'title prefixes' do
    it 'do not duplicate boring numbers' do
      expect(Chapter.first.title_prefix).to eq ''
    end

    it 'do add numbers to interesting' do
      expect(Chapter.second.title_prefix).to eq '2. '
    end
  end
end
