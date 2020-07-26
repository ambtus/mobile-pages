class ChangeColumnName < ActiveRecord::Migration[6.0]
  def up
    Page.where(favorite: nil).update_all(favorite: 10) # cleaning up old default
    Page.where(last_read: nil).where(favorite: 0).update_all(favorite: 10) # cleaning up old weirdnesses
    Page.where(favorite: 0).update_all(favorite: 5) # 0 is now 5 stars
      Page.where(favorite: 1).update_all(favorite: 7) # hold
    Page.where(favorite: 4).update_all(favorite: 1) # 4 is now 1 star
    Page.where(favorite: 7).update_all(favorite: 4) # 1 is now 4 stars
      Page.where(favorite: 2).update_all(favorite: 8) # hold
    Page.where(favorite: 3).update_all(favorite: 2) # 3 is now 2 stars
    Page.where(favorite: 8).update_all(favorite: 3) # 2 is now 3 stars
    rename_column :pages, :favorite, :stars
    interesting = Rating.find_or_create_by(name: "interesting")
    interesting.pages << Page.where(interesting: 0)
    interesting.pages.map(&:cache_tags)
    boring = Omitted.find_or_create_by(name: "boring")
    boring.pages << Page.where(interesting: 2)
    boring.pages.map(&:cache_tags)
    remove_column :pages, :interesting
    loving = Rating.find_or_create_by(name: "loving")
    loving.pages << Page.where(nice: 0)
    loving.pages.map(&:cache_tags)
    hateful = Omitted.find_or_create_by(name: "hateful")
    hateful.pages << Page.where(nice: 2)
    hateful.pages.map(&:cache_tags)
    remove_column :pages, :nice
  end
  def down
    rename_column :pages, :stars, :favorite
    Page.where(favorite: 3).update_all(favorite: 8) # hold
    Page.where(favorite: 2).update_all(favorite: 3) # 2 stars back to 3rd favorite
    Page.where(favorite: 8).update_all(favorite: 2) # 3 stars back to 2nd favorite
    Page.where(favorite: 4).update_all(favorite: 7) # hold
    Page.where(favorite: 1).update_all(favorite: 4) # 1 star back to 4th favorite
    Page.where(favorite: 7).update_all(favorite: 1) # 4 stars back to 1st favorite
    Page.where(favorite: 5).update_all(favorite: 0) # 5 stars back to super favorite
    add_column :pages, :interesting, :int
    add_column :pages, :nice, :int
  end
end
