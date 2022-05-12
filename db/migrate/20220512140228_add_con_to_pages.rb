class AddConToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :con, :boolean, :default => false
  end
end
