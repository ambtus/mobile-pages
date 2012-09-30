class AddGenreString < ActiveRecord::Migration
  def up
    add_column :pages, :cached_genre_string, :string, :default => "", :null => false
    Page.update_genre_strings
  end

  def down
    remove_column :pages, :cached_genre_string
  end
end
