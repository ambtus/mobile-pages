# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pro, type: :model do
  it 'is a type of tag' do
    described_class.create(name: 'testing')

    expect(Tag.first.class).to be described_class
  end
end
