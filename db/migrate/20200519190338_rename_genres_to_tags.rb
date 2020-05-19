class RenameGenresToTags < ActiveRecord::Migration[6.0]
  def change
    rename_table :genres, :tags
    rename_index :tags, "genre_name", "tag_name"
    rename_table :genres_pages, :pages_tags
    rename_column :pages_tags, :genre_id, :tag_id
    rename_column :pages, :cached_genre_string, :cached_tag_string
  end
end
