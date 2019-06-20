class DropUserTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :users do |t|
      t.string :name
      t.string :password_digest

      t.timestamps
    end
  end
end
