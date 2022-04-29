class AddEndNotesToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :end_notes, :text, size: :medium
    add_column :pages, :at_end, :boolean, :default => false
  end
end
