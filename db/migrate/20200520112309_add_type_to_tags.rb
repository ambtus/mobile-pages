class AddTypeToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :type, :string, :default => "", :null => false
    add_index :tags, ["type"], :name => "tag_type"
  end
end
