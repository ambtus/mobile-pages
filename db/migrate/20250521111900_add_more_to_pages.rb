class AddMoreToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :wip, :boolean, :default => false
    add_column :pages, :favorite, :boolean, :default => false
  end
end
