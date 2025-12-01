# frozen_string_literal: true

class AddUniqueIndexToTagsOnName < ActiveRecord::Migration[8.1]
  def change
    add_index :tags, [:name, :type], unique: true
  end
end
