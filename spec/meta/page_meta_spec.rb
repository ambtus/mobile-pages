# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageMeta, type: :module do
  it 'does not match characters' do
    create_multi_fandoms
    expect(Page.first.notes).not_to match 'Severus Snape'
  end

  describe 'parsing additional tags' do
    it 'matches additional tags' do
      create_multi_fandoms
      expect(Page.first.notes).to match 'Alan Rickman'
    end

    it 'drops the freeform' do
      pending 'bug fix'
      create_multi_fandoms

      expect(Page.first.notes).not_to match 'Freeform'
    end
  end
end
