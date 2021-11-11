class AddTypeToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :type, :string
  end
end
