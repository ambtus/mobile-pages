class DropAuthors < ActiveRecord::Migration[7.0]
  def up
    pages = []
    Author.all.each do |author|
      tag = Tag.find_or_create_by(name: author.name, type: Author)
      author.pages.each do |page|
        page.tags << tag
        pages << page
      end
    end
    pages.map(&:cache_tags)
    drop_table :authors_pages
    drop_table :authors
  end
  def down
    create_table "authors" do |t|
      t.string "name"
      t.index ["name"], name: "author_name", unique: true
    end

    create_table "authors_pages", id: false do |t|
      t.integer "page_id"
      t.integer "author_id"
    end

    page_ids = []
    Tag.authors.each do |tag|
      author = Author.create!(name: tag.name)
      tag.pages.each do |page|
        page.authors << author
        page_ids << page.id
      end
      tag.destroy!
    end
    page_ids.each {|id| Page.find(id).cache_tags}
  end
end
