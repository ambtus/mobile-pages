# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageScrubbed, type: :module do
  it 'saves the scrubbed html to file' do
    page = Page.create!(title: 'temp')
    page.raw_html = '<div>This is a test</div>'

    expect(File.exist?(page.scrubbed_html_file_name)).to be true
  end

  it 'saves the scrubbed html without surrounding div' do
    page = Page.create!(title: 'temp')
    page.raw_html = '<div>This is a test</div>'

    expect(page.scrubbed_html).to eq 'This is a test'
  end

  it 'removes single surrounding p' do
    page = Page.create(title: 'temp')
    page.raw_html = '<p>This is a test</p>'
    expect(page.scrubbed_html).to eq 'This is a test'
  end

  it 'doesnt exist for books' do
    create_book

    expect(Book.first.scrubbed_html).to be_nil
  end

  it 'is blank if directory is gone' do
    create_book

    Chapter.first.remove_directory
    expect(Chapter.first.scrubbed_html).to eq ''
  end
end
