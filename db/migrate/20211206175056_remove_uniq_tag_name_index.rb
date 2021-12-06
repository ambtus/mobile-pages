class RemoveUniqTagNameIndex < ActiveRecord::Migration[6.1]
  def up
    remove_index :tags, :name => 'tag_name'
    add_index :tags, :name, :name => 'tag_name'
  end
  def down
    remove_index :tags, :name => 'tag_name'
    add_index :tags, :name, unique: true, :name => 'tag_name'
  end

end
