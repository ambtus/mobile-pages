class Remove < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :sanitize_version
  end
end
