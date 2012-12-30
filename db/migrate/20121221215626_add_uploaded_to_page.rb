class AddUploadedToPage < ActiveRecord::Migration
  def change
    add_column :pages, :uploaded, :boolean, :default => false
  end
end
