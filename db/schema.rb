# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_01_10_417523) do

  create_table "authors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "author_name", unique: true
  end

  create_table "authors_pages", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "page_id"
    t.integer "author_id"
  end

  create_table "genres", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "genre_name", unique: true
  end

  create_table "genres_pages", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "page_id"
    t.integer "genre_id"
  end

  create_table "hiddens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "hidden_name", unique: true
  end

  create_table "hiddens_pages", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "page_id"
    t.integer "hidden_id"
  end

  create_table "pages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.text "notes", limit: 16777215
    t.integer "parent_id"
    t.integer "position"
    t.datetime "last_read"
    t.datetime "read_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "wordcount"
    t.string "size"
    t.integer "favorite", limit: 2, default: 10
    t.integer "ultimate_parent_id"
    t.integer "sanitize_version", limit: 2, default: 1, null: false
    t.string "cached_genre_string", default: "", null: false
    t.integer "interesting"
    t.integer "nice"
    t.string "cached_hidden_string", default: "", null: false
    t.text "my_notes"
    t.index ["favorite"], name: "index_pages_on_favorite"
    t.index ["parent_id"], name: "index_pages_on_parent_id"
    t.index ["size"], name: "index_pages_on_size", length: 250
    t.index ["ultimate_parent_id"], name: "index_pages_on_ultimate_parent_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
  end

end
