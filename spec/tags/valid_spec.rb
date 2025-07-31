# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  it 'is valid with a name' do
    tag = described_class.new(name: 'hello world')
    expect(tag).to be_valid
  end

  it 'is NOT valid without a name' do
    tag = described_class.new
    expect(tag).not_to be_valid
  end

  it 'cannot have the same name' do
    described_class.create(name: 'hello')
    tag2 = described_class.new(name: 'Hello')
    expect(tag2).not_to be_valid
  end

  it "can have the same name if it's a different type" do
    Fandom.create(name: 'hello')
    tag2 = Author.new(name: 'Hello')
    expect(tag2).to be_valid
  end

  it 'cannot have the same base name' do
    pending 'oops?'
    described_class.create(name: 'hello')
    tag2 = described_class.new(name: 'hello (world)')
    expect(tag2).not_to be_valid
  end
end
