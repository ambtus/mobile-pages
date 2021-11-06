class ConvertDatabaseToUtf8mb4 < ActiveRecord::Migration[6.1]
  def change
   # for each table that will store unicode execute:
    execute "ALTER TABLE pages CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
end
