class AddSanitizerVersion < ActiveRecord::Migration
  def self.up
    add_column :pages, :sanitize_version, :integer, :default => 1, :null => false, :limit => 2
  end

  def self.down
    remove_column :pages, :sanitize_version
  end
end
