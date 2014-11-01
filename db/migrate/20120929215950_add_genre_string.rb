class AddGenreString < ActiveRecord::Migration
  def up
    add_column :pages, :cached_genre_string, :string, :default => "", :null => false
  end

  def down
    remove_column :pages, :cached_genre_string
  end
end
