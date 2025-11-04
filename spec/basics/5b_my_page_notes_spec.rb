# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageNotes, type: :module do
  it 'starts blank' do
    page = Page.create!(title: 'temp')
    expect(page.my_notes).to be_blank
  end

  it 'is saved as is' do
    page = Page.create!(title: 'temp', my_notes: ' foo ')
    expect(page.my_notes).to eq ' foo '
  end

  it 'is shown clean' do
    page = Page.create!(title: 'temp', my_notes: ' foo ')

    expect(page.formatted_my_notes).to eq 'foo'
  end
end
