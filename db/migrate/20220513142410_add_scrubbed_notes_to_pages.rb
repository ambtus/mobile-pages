class AddScrubbedNotesToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :scrubbed_notes, :boolean, :default => false
  end
end
