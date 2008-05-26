# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080526162952) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.string   "openid_url"
    t.string   "name"
    t.string   "email"
    t.string   "url"
    t.datetime "created_at"
    t.string   "auth"
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "ip"
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.string   "url"
    t.text     "text"
    t.string   "artist"
    t.integer  "length"
    t.string   "external_id"
    t.datetime "made_at"
    t.string   "external_file_url"
    t.boolean  "published",         :default => true
    t.string   "type"
    t.text     "short_text"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",                  :null => false
    t.string  "server_url"
    t.string  "salt",       :default => "", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
    t.string   "openid_url"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string "openid_url"
    t.string "permission"
  end

end
