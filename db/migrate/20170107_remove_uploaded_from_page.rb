class RemoveUploadedFromPage < ActiveRecord::Migration
  def change
    remove_column :pages, :uploaded, :boolean, :default => false
  end
end
