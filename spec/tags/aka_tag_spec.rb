# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'adding an aka' do
    before do
      fandom
      author
      described_class.first.add_aka(author)
    end

    it 'adds aka in parents' do
      expect(described_class.first.name).to eq 'Harry Potter (Sidra)'
    end

    it 'destroys the original' do
      expect(described_class.count).to be 1
    end
  end
end
