class AddSizes < ActiveRecord::Migration
  def self.up
    add_column :pages, :size, :string
    add_column :pages, :favorite, :boolean, :default => false
    add_index :pages, :size
    add_index :pages, :favorite
    add_index :pages, :parent_id
    Page.reset_column_information 

# running migration using pure sql, because state model has already been removed.
    short_state_id = select_values("SELECT id FROM `states` WHERE (`name` = 'short')").first
    if short_state_id
      execute "UPDATE `pages` INNER JOIN `pages_states` ON `pages`.id = `pages_states`.page_id SET size = 'short' WHERE (`pages_states`.state_id = #{short_state_id} )"
    end

    long_state_id = select_values("SELECT id FROM `states` WHERE (`name` = 'long')").first
    if long_state_id
      execute "UPDATE `pages` INNER JOIN `pages_states` ON `pages`.id = `pages_states`.page_id SET size = 'long' WHERE (`pages_states`.state_id = #{long_state_id} )"
    end

    epic_state_id = select_values("SELECT id FROM `states` WHERE (`name` = 'epic')").first
    if epic_state_id
      execute "UPDATE `pages` INNER JOIN `pages_states` ON `pages`.id = `pages_states`.page_id SET size = 'epic' WHERE (`pages_states`.state_id = #{epic_state_id} )"
    end

    favorite_state_id = select_values("SELECT id FROM `states` WHERE (`name` = 'epic')").first
    if favorite_state_id
      execute "UPDATE `pages` INNER JOIN `pages_states` ON `pages`.id = `pages_states`.page_id SET favorite = true WHERE (`pages_states`.state_id = #{favorite_state_id} )"
    end

    unread_pages = Page.unread
    unread_state_id = select_values("SELECT id FROM `states` WHERE (`name` = 'unread')").first
    page_ids_marked_unread = select_values("SELECT page_id FROM `pages_states` WHERE (`state_id` = #{unread_state_id})")
    fix = unread_pages - Page.find_all_by_id(page_ids_marked_unread) - Page.ultimate_parents
    puts "updating #{fix.size} children"
    fix.each do |page|
      print "." if page.id.modulo(10) == 0; STDOUT.flush
      page.update_attribute(:last_read, page.parent.last_read)
    end
    puts ""
    
    drop_table :states
    drop_table :pages_states

  end

  def self.down
    #too much work to write
  end
end
