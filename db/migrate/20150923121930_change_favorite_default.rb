class ChangeFavoriteDefault < ActiveRecord::Migration
  def up
    change_column_default :pages, :favorite, 10
    Page.where(:last_read => nil).where(:favorite => 0).update_all("favorite = 10")
  end

  def down
    change_column_default :pages, :favorite, 0
    Page.where(:last_read => nil).where(:favorite => 10).update_all("favorite = 0")
  end
end
