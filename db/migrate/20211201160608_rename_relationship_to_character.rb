class RenameRelationshipToCharacter < ActiveRecord::Migration[6.1]
  def up
    Tag.where(type: "Relationship").update_all(type: 'Character')
  end
  def down
    Tag.where(type: "Character").update_all(type: 'Relationship')
  end
end
