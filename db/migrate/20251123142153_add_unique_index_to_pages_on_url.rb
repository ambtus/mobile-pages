# frozen_string_literal: true

class AddUniqueIndexToPagesOnUrl < ActiveRecord::Migration[8.1]
  def change
    add_index :pages, :url, unique: true, where: 'page_url IS NOT NULL'
  end
end
