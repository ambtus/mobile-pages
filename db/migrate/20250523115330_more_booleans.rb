class MoreBooleans < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :author, :boolean, :default => false
    add_column :pages, :fandom, :boolean, :default => false
  end
end
