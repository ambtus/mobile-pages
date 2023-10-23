class AddReaderToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :reader, :boolean, :default => false
  end
  Reader.recache_all
  Con.recache_all
  Pro.recache_all
  Hidden.recache_all
end
