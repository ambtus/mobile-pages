# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.file_fixture_path = 'spec/html_files'
end

RSpec.describe 'scrubbed HTML' do
  it 'expects a body' do
    page = Page.create(title: 'temp')
    page.raw_html = 'This is a test'
    expect page.scrubbed_html == '<body><p>This is a test</p></body>'
  end
end
