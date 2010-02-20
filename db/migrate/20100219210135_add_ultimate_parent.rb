class AddUltimateParent < ActiveRecord::Migration
  def self.up
    add_column :pages, :ultimate_parent_id, :integer
    add_index :pages, :ultimate_parent_id
    Page.reset_column_information
    Page.all.each { |p| p.update_attribute(:ultimate_parent_id, p.find_ultimate_parent.id)}
  end

  def self.down
    remove_column :pages, :ultimate_parent_id
  end
end
