# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.file_fixture_path = 'spec/html_files'
end

RSpec.describe Scrubbed, type: :module do
  it 'removes single surrounding div' do
    page = Page.create(title: 'temp')
    page.raw_html = '<b>This is a test</p>'
    expect(page.scrubbed_html).to eq 'This is a test'
  end
end
