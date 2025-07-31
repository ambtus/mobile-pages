# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.file_fixture_path = 'spec/html_files'
end

RSpec.describe 'raw HTML' do
  it 'starts blank' do
    page = Page.create(title: 'temp')
    expect(page.raw_html).to eq('')
  end

  it 'can accept plain text' do
    string = 'xyzzy'
    page = Page.create(title: 'temp')
    page.raw_html = string
    expect(page.raw_html).to match(string)
  end

  it 'can be reset to blank' do
    page = Page.create(title: 'temp')
    page.raw_html = 'xyzzy'
    page.raw_html = ''
    expect(page.raw_html).to eq('')
  end

  it 'is blank when set to nil' do
    page = Page.create(title: 'temp')
    page.raw_html = nil
    expect(page.raw_html).to eq('')
  end

  it 'is blank when directory is missing' do
    page = Page.create(title: 'temp')
    page.raw_html = 'xyzzy'
    page.remove_directory
    expect(page.raw_html).to eq('')
  end

  it 'can be set when directory is missing' do
    page = Page.create(title: 'temp')
    page.remove_directory
    page.raw_html = 'xyzzy'
    expect(page.raw_html).to match('xyzzy')
  end

  it 'converts winlatin1 encodings' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('winlatin1.html').read
    expect(page.raw_html).to match('“Hello…”')
    expect(page.raw_html).to match('Don’t—')
    expect(page.raw_html).to match('€')
  end

  it 'fixes entities' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('entities.html').read
    expect(page.raw_html).to match('antsy—boggart')
    expect(page.raw_html).to match('world’s')
    expect(page.raw_html).to match(' ')
  end

  it 'removes javascript' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('javascript.html').read
    expect(page.raw_html).not_to match('email Vera')
  end

  it 'saves only the body' do
    page = Page.create(title: 'temp')
    page.raw_html = '<head><title>Title</title></head><body><p>xyzzy</p></body>'
    expect(page.raw_html).not_to match('Title')
    expect(page.raw_html).to match('xyzzy')
  end
end
