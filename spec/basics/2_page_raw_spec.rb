# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageRaw, type: :module do
  it 'saves the raw html to file' do
    page = Page.create!(title: 'temp')
    page.raw_html = '<p>This is a test</p>'

    expect(File.exist?(page.raw_html_file_name)).to be true
  end

  it 'saves only the body of the html' do
    page = Page.create!(title: 'temp')
    page.raw_html = '<html><head><title>foo</title></head><body><p>bar</p></body></html>'

    expect(page.raw_html).to eq '<p>bar</p>'
  end

  it 'saves plain text as plain text' do
    page = Page.create!(title: 'temp')
    page.raw_html = 'plain text'

    expect(page.raw_html).to eq 'plain text'
  end

  it 'gets raw from the web' do
    page = create_retrieved
    skip "fetch failed: #{page.errors.inspect}, skipping test" if page.errors.present?

    expect(Page.first.raw_html).to eq '<p>Retrieved from the web</p>'
  end

  it 'replaces html' do
    create_retrieved
    Page.first.raw_html = ''

    expect(Page.first.raw_html).to eq ''
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
    page = create_local_page('winlatin1')
    expect(page.raw_html).to match('“Hello…”')
  end

  it 'converts winlatin1 euro' do
    page = create_local_page('winlatin1')
    expect(page.raw_html).to match('€')
  end

  it 'converts winlatin1 emdash and quote' do
    page = create_local_page('winlatin1')
    expect(page.raw_html).to match('Don’t—')
  end

  it 'fixes emdash entities' do
    page = create_local_page('entities')
    expect(page.raw_html).to match('antsy—boggart')
  end

  it 'fixes quote entities' do
    page = create_local_page('entities')
    expect(page.raw_html).to match('world’s')
  end

  it 'removes nbsp entities' do
    page = create_local_page('entities')
    expect(page.raw_html).not_to match('nbsp')
  end

  it 'removes javascript when pasted' do
    page = create_local_page('javascript')

    expect(page.raw_html).not_to match('email Vera')
  end

  it 'removes javascript when fetched' do
    page = Page.create(url: 'http://test.sidrasue.com/112b.html')
    page.initial_fetch

    expect(Page.first.raw_html).not_to match 'email Vera'
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
