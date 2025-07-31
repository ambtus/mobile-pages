# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page, type: :model do
  it 'is valid with both a title and a url' do
    page = described_class.new(title: 'hello world', url: 'https://www.test.com/hello_world')
    expect(page).to be_valid
  end

  it 'is valid with only a title' do
    page = described_class.new(title: 'hello world')
    expect(page).to be_valid
  end

  it 'is valid with only a url' do
    page = described_class.new(url: 'https://www.test.com/hello_world')
    expect(page).to be_valid
  end

  it 'is NOT valid without a title or url' do
    page = described_class.new
    expect(page).not_to be_valid
  end

  it 'is NOT valid with an invalid url' do
    page = described_class.new(url: 'hello world')
    expect(page).not_to be_valid
  end

  it 'is NOT valid with a partial url' do
    page = described_class.new(url: 'www.test.com/hello_world')
    expect(page).not_to be_valid
  end
end
