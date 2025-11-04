# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageEdited, type: :module do
  it 'saves edited html to file' do
    page = Page.create!(title: 'temp')
    page.edited_html = '<div>This is a test</div>'

    expect(File.exist?(page.edited_html_file_name)).to be true
  end

  it 'saves the edited html without surrounding div' do
    page = Page.create!(title: 'temp')
    page.edited_html = '<div>This is a test</div>'

    expect(page.edited_html).to eq 'This is a test'
  end

  it 'returns the scrubbed html if not edited' do
    page = Page.create!(title: 'temp')
    page.raw_html = '<div>This is a test</div>'

    expect(page.edited_html).to eq 'This is a test'
  end
end
