class AddMyNotesToPage < ActiveRecord::Migration
  def change
    add_column :pages, :my_notes, :text
  end
end
