class AddTagCacheToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :tag_cache, :string, default: '', null: false
  end
end
