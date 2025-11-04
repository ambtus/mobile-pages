# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageNotes, type: :module do
  it 'starts blank' do
    page = Page.create!(title: 'temp')
    expect(page.notes).to be_blank
  end

  it 'are saved as is' do
    page = Page.create(title: 'temp')
    page.update(notes: 'This is fun & cute <3')
    expect(page.notes).to eq('This is fun & cute <3')
  end

  it 'truncated version of no note' do
    page = Page.create(title: 'temp')
    expect(page.truncate(page.notes)).to eq ''
  end

  it 'short version is html safe' do
    page = Page.create(title: 'temp')
    page.update(notes: 'This is fun & cute <3')
    expect(page.short_notes).to eq('This is fun &amp; cute &lt;3')
  end

  it 'formatted version is html safe' do
    page = Page.create(title: 'temp')
    page.update(notes: 'This is fun & cute <3')
    expect(page.formatted_notes).to eq('This is fun &amp; cute &lt;3')
  end

  it 'short version scrubs html and replaces hr with ;' do
    page = Page.create(title: 'temp')
    page.update(notes: html_note)
    expect(page.short_notes.squish).to eq('This. is not. actually. a very long. note; (once you take out the html)')
  end

  it 'medium version retains links' do
    page = Page.create(title: 'temp')
    page.update(notes: html_note)
    expect(page.medium_notes).to match('<a href=')
  end

  it 'short version converts multiple ~ to hr' do
    page = Page.create(title: 'temp')
    page.update(notes: tilde_note)
    expect(page.short_notes).to eq('Sorry it took so long, I suck at romantic stuff.; Cheers!')
  end

  it 'medium version converts multiple ~ to hr' do
    page = Page.create(title: 'temp')
    page.update(notes: tilde_note)
    expect(page.medium_notes).to eq fixed_tilde_note
  end

  it 'short version is truncated' do
    page = Page.create(title: 'temp', notes: very_long_note)
    expect(page.short_notes).to eq(truncated_short_note)
  end

  it 'medium version is longer but still truncated' do
    page = Page.create(title: 'temp', notes: very_long_note)
    expect(page.medium_notes).to eq(truncated_medium_note)
  end
end
