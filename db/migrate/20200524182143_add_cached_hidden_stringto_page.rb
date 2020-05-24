class AddCachedHiddenStringtoPage < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :cached_hidden_string, :string, :default => "", :null => false
  end
end
