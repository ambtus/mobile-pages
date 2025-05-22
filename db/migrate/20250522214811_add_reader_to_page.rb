class AddReaderToPage < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :reader, :boolean, :default => false
    remove_column :pages, :audio_url, :string
  end
end
