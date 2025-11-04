# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  before do
    fandom
    author
    described_class.first.add_aka(author)
  end

  it 'can be given an aka' do
    expect(described_class.first.name).to eq 'Harry Potter (Sidra)'
  end

  it 'destroys the aka' do
    expect(described_class.count).to be 1
  end
end
