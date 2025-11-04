# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageNotes, type: :module do
  it 'starts blank' do
    page = Page.create!(title: 'temp')
    expect(page.end_notes).to be_blank
  end

  it 'is saved as is' do
    page = Page.create!(title: 'temp', end_notes: ' foo ')
    expect(page.end_notes).to eq ' foo '
  end

  it 'is shown clean' do
    page = Page.create!(title: 'temp', end_notes: ' foo ')

    expect(page.formatted_end_notes).to eq 'foo'
  end

  it 'is at the beginning by default' do
    page = Page.create!(title: 'temp', end_notes: ' foo ')

    expect(page.at_end).to be false
  end

  it 'can be shown at the end' do
    page = Page.create!(title: 'temp', end_notes: ' foo ', at_end: true)
    expect(page.at_end).to be true
  end
end
