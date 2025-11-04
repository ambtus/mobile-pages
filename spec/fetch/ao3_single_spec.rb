# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Single, type: :class do
  before(:context) do
    skip 'skipping ao3 unless requested' if ENV['AO3'].blank?
    page = Page.create url: 'https://archiveofourown.org/works/688'
    page.initial_fetch
    skip "Single fetch failed: #{page.errors.inspect}, skipping tests" if page.errors.present?
  end

  after(:context) { Page.destroy_all }

  it 'makes me a single' do
    expect(Page.first.class).to be described_class
  end

  it 'gets the raw html' do
    file_path = Page.first.raw_html_file_name
    result = File.exist?(file_path) && !File.empty?(file_path)
    expect(result).to be true
  end

  it 'sets the title' do
    expect(Page.first.title).to eq 'Skipping Stones'
  end

  it 'adds the author to notes' do
    expect(Page.first.notes).to match 'by Sidra'
  end

  it 'adds the fandom to notes' do
    expect(Page.first.notes).to match 'Harry Potter'
  end

  it 'adds other tags to notes' do
    expect(Page.first.notes).to match 'Drabble'
  end

  it 'puts the page notes in notes' do
    expect(Page.first.notes).to match 'thanks'
  end

  it 'does not have an end note' do
    expect(Page.first.end_notes.blank?).to be true
  end

  it 'is not a wip' do
    expect(Page.first.wip?).to be false
  end
end
