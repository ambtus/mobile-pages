# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Series, type: :model do
  it 'can have unread parts' do
    unread_series

    expect(Chapter.first).to be_unread
  end
end
