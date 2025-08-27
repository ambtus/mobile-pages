# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.file_fixture_path = 'spec/html_files'
end

RSpec.describe Raw, type: :module do
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

  it 'converts winlatin1 elipse' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('winlatin1.html').read
    expect(page.raw_html).to match('“Hello…”')
  end

  it 'converts winlatin1 euro' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('winlatin1.html').read
    expect(page.raw_html).to match('€')
  end

  it 'converts winlatin1 emdash and quote' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('winlatin1.html').read
    expect(page.raw_html).to match('Don’t—')
  end

  it 'fixes emdash entities' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('entities.html').read
    expect(page.raw_html).to match('antsy—boggart')
  end

  it 'fixes quote entities' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('entities.html').read
    expect(page.raw_html).to match('world’s')
  end

  it 'removes nbsp entities' do
    page = Page.create(title: 'temp')
    page.raw_html = file_fixture('entities.html').read
    expect(page.raw_html).not_to match('nbsp')
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
  end

  it 'does save the body' do
    page = Page.create(title: 'temp')
    page.raw_html = '<head><title>Title</title></head><body><p>xyzzy</p></body>'
    expect(page.raw_html).to match('xyzzy')
  end
end
