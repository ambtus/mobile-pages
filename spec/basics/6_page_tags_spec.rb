# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageTags, type: :module do
  it 'can have tags' do
    page = create_book
    page.tags << [fandom, author]
    page.update_tag_caches

    expect(Book.first.tags.count).to be 2
  end
end
