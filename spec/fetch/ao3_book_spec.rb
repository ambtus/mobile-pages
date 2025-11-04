# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :class do
  before(:context) do
    skip 'skipping ao3 unless requested' if ENV['AO3'].blank?
    page = Page.create url: 'https://archiveofourown.org/works/692'
    page.initial_fetch
    skip "Book fetch failed: #{page.errors.inspect}, skipping tests" if page.errors.present?
  end

  after(:context) { Page.destroy_all }

  it 'keeps me a book' do
    expect(Page.first.class).to be described_class
  end

  it 'has two parts' do
    expect(Page.first.parts.count).to be 2
  end

  it 'has navigate file' do
    expect(File.exist?(described_class.first.navigate_html_file_name)).to be true
  end

  it 'but not a raw file' do
    expect(File.exist?(described_class.first.raw_html_file_name)).to be false
  end

  it 'sets the title' do
    expect(Page.first.title).to eq 'Time Was, Time Is'
  end

  it 'adds the author to notes' do
    expect(Page.first.notes).to match 'by Sidra'
  end

  it 'adds the fandom to notes' do
    expect(Page.first.notes).to match 'Harry Potter'
  end

  it 'adds other tags to notes' do
    expect(Page.first.notes).to match 'abandoned'
  end

  it 'puts the page notes in notes' do
    expect(Page.first.notes).to match 'Using'
  end

  it 'does not have an end note' do
    expect(Page.first.end_notes.blank?).to be true
  end

  it 'does have an end note on the second chapter' do
    expect(Page.last.end_notes).to match 'giving up'
  end

  it 'is a wip' do
    expect(Page.first.wip?).to be true
  end
end
