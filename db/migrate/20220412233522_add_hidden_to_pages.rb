class AddHiddenToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :hidden, :boolean, :default => false
    remove_column :pages, :cached_tag_string, :string
    remove_column :pages, :cached_hidden_string, :string
  end
end
