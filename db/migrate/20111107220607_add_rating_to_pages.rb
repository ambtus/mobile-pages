class AddRatingToPages < ActiveRecord::Migration
  def self.up
    change_column :pages, :favorite, :integer, :limit => 2
  end

  def self.down
    change_column :pages, :favorite, :boolean
  end
end
