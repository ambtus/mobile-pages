# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_01_160608) do

  create_table "authors", id: :integer, charset: "utf8", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "author_name", unique: true
  end

  create_table "authors_pages", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "page_id"
    t.integer "author_id"
  end

  create_table "pages", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.text "notes", size: :medium
    t.integer "parent_id"
    t.integer "position"
    t.datetime "last_read"
    t.datetime "read_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "wordcount"
    t.string "size"
    t.integer "stars", limit: 2, default: 10
    t.integer "ultimate_parent_id"
    t.integer "sanitize_version", limit: 2, default: 1, null: false
    t.string "cached_tag_string", default: "", null: false
    t.text "my_notes"
    t.string "cached_hidden_string", default: "", null: false
    t.string "type"
    t.index ["parent_id"], name: "index_pages_on_parent_id"
    t.index ["size"], name: "index_pages_on_size", length: 250
    t.index ["stars"], name: "index_pages_on_stars"
    t.index ["ultimate_parent_id"], name: "index_pages_on_ultimate_parent_id"
  end

  create_table "pages_tags", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "page_id"
    t.integer "tag_id"
  end

  create_table "tags", id: :integer, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "name"
    t.string "type", default: "", null: false
    t.index ["name"], name: "tag_name", unique: true
    t.index ["type"], name: "tag_type"
  end

end
