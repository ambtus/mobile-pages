class RemoveFromPages < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :ultimate_parent_id
    remove_column :pages, :reader
  end
end
