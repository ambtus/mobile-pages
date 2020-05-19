class DropHiddens < ActiveRecord::Migration[6.0]
  def up
    remove_column :pages, :cached_hidden_string
    drop_table :hiddens
    drop_table :hiddens_pages
  end

  def down
    add_column :pages, :cached_hidden_string, :string, :default => "", :null => false
    create_table :hiddens do |t|
      t.string :name
    end
    create_table "hiddens_pages", :id => false, :force => true do |t|
      t.integer "page_id"
      t.integer "hidden_id"
    end
    add_index "hiddens", ["name"], :name => "hidden_name", :unique => true

  end
end
