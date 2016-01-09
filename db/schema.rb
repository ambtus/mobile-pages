# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151229203412) do

  create_table "authors", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "authors", ["name"], name: "author_name", unique: true, using: :btree

  create_table "authors_pages", id: false, force: :cascade do |t|
    t.integer "page_id",   limit: 4
    t.integer "author_id", limit: 4
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "genres", ["name"], name: "genre_name", unique: true, using: :btree

  create_table "genres_pages", id: false, force: :cascade do |t|
    t.integer "page_id",  limit: 4
    t.integer "genre_id", limit: 4
  end

  create_table "hiddens", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "hiddens", ["name"], name: "hidden_name", unique: true, using: :btree

  create_table "hiddens_pages", id: false, force: :cascade do |t|
    t.integer "page_id",   limit: 4
    t.integer "hidden_id", limit: 4
  end

  create_table "pages", force: :cascade do |t|
    t.string   "url",                  limit: 255
    t.string   "title",                limit: 255
    t.text     "notes",                limit: 16777215
    t.integer  "parent_id",            limit: 4
    t.integer  "position",             limit: 4
    t.datetime "last_read"
    t.datetime "read_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wordcount",            limit: 4
    t.string   "size",                 limit: 255
    t.integer  "favorite",             limit: 2,        default: 10
    t.integer  "ultimate_parent_id",   limit: 4
    t.integer  "sanitize_version",     limit: 2,        default: 1,     null: false
    t.string   "cached_genre_string",  limit: 255,      default: "",    null: false
    t.integer  "interesting",          limit: 4
    t.integer  "nice",                 limit: 4
    t.boolean  "uploaded",                              default: false
    t.string   "cached_hidden_string", limit: 255,      default: "",    null: false
  end

  add_index "pages", ["favorite"], name: "index_pages_on_favorite", using: :btree
  add_index "pages", ["parent_id"], name: "index_pages_on_parent_id", using: :btree
  add_index "pages", ["size"], name: "index_pages_on_size", length: {"size"=>250}, using: :btree
  add_index "pages", ["ultimate_parent_id"], name: "index_pages_on_ultimate_parent_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "auth_token",      limit: 255
  end

end
