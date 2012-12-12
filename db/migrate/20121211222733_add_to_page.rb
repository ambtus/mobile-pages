class AddToPage < ActiveRecord::Migration
  def change
    add_column :pages, :interesting, :integer
    add_column :pages, :nice, :integer
  end
end
