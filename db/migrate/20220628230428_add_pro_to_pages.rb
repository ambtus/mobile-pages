class AddProToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :pro, :boolean, :default => false
  end
end
