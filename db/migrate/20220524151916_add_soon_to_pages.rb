class AddSoonToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :soon, :integer, limit: 2, default: 3
  end
end
