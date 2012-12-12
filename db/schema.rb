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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121211222733) do

  create_table "authors", :force => true do |t|
    t.string "name"
  end

  add_index "authors", ["name"], :name => "author_name", :unique => true

  create_table "authors_pages", :id => false, :force => true do |t|
    t.integer "page_id"
    t.integer "author_id"
  end

  create_table "genres", :force => true do |t|
    t.string "name"
  end

  add_index "genres", ["name"], :name => "genre_name", :unique => true

  create_table "genres_pages", :id => false, :force => true do |t|
    t.integer "page_id"
    t.integer "genre_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "notes"
    t.integer  "parent_id"
    t.integer  "position"
    t.datetime "last_read"
    t.datetime "read_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wordcount"
    t.string   "size"
    t.integer  "favorite",            :limit => 2, :default => 0
    t.integer  "ultimate_parent_id"
    t.integer  "sanitize_version",    :limit => 2, :default => 1,  :null => false
    t.string   "cached_genre_string",              :default => "", :null => false
    t.integer  "interesting"
    t.integer  "nice"
  end

  add_index "pages", ["favorite"], :name => "index_pages_on_favorite"
  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["size"], :name => "index_pages_on_size"
  add_index "pages", ["ultimate_parent_id"], :name => "index_pages_on_ultimate_parent_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "auth_token"
  end

end
