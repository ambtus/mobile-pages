# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageTitles, type: :model do
  it 'creates a temporary title' do
    create_retrieved

    expect(Page.first.title).to eq 'xyzzy'
  end

  it 'is valid with both a title and a url' do
    page = Page.new(title: 'hello world', url: 'https://www.test.com/hello_world')
    expect(page).to be_valid
  end

  it 'is valid with only a title' do
    page = Page.new(title: 'hello world')
    expect(page).to be_valid
  end

  it 'is valid with only a url' do
    page = Page.new(url: 'https://www.test.com/hello_world')
    expect(page).to be_valid
  end

  it 'is NOT valid without a title or url' do
    page = Page.new
    expect(page).not_to be_valid
  end
end
