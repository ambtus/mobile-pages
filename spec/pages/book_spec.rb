# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('features/support/book_helpers').to_s

RSpec.describe Book, type: :model do
  it 'doesnt change the original chapter position' do
    partial_book.add_chapter(first_chapter.url)
    first_chapter.reload

    expect(first_chapter.position).to be 1
  end
end
