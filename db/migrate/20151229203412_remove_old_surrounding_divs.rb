class RemoveOldSurroundingDivs < ActiveRecord::Migration
  def up
    Page.all do |page|
      page.remove_old_surrounding
    end
  end

  def down
  end
end
