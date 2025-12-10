# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageUrls, type: :module do
  describe 'it sets an intial type' do
    it 'is a Single with a chapter url' do
      create_chapter_as_single

      expect(Page.first.class).to be Single
    end

    it 'is first a Single with a chapter url even if it becomes a chapter later' do
      create_first_chapter

      expect(Page.first.class).to be Single
    end

    it 'is a Book with a work url' do
      create_time_book

      expect(Page.last.class).to be Book
    end

    it 'is a Series with a series url' do
      create_series

      expect(Page.last.class).to be Series
    end
  end

  describe 'it normalizes the url' do
    it 'removes whitespace' do
      Page.create!(url: ' http://test.sidrasue.com/test.html ')

      expect(Page.first.url).to eq 'http://test.sidrasue.com/test.html'
    end

    it 'removes #workskin' do
      Page.create!(url: 'https://archiveofourown.org/works/35366320/chapters/88150261#workskin')

      expect(Page.first.url).to eq 'https://archiveofourown.org/works/35366320/chapters/88150261'
    end
  end

  it 'is NOT valid with an invalid url' do
    page = Page.new(url: 'hello world')
    expect(page).not_to be_valid
  end

  it 'is NOT valid with a partial url' do
    page = Page.new(url: 'www.test.com/hello_world')
    expect(page).not_to be_valid
  end
end
