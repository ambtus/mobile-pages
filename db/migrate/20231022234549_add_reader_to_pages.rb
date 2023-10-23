class AddReaderToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :reader, :boolean, :default => false
  end
end
