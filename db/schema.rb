# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 23) do

  create_table "comments", :force => true do |t|
    t.column "content",    :text
    t.column "openid_url", :string
    t.column "name",       :string
    t.column "email",      :string
    t.column "url",        :string
    t.column "created_at", :datetime
    t.column "auth",       :string
    t.column "item_id",    :integer
    t.column "item_type",  :string
    t.column "ip",         :string
  end

  create_table "items", :force => true do |t|
    t.column "title",             :string
    t.column "created_at",        :datetime
    t.column "url",               :string
    t.column "text",              :text
    t.column "artist",            :string
    t.column "length",            :integer
    t.column "external_id",       :string
    t.column "made_at",           :datetime
    t.column "external_file_url", :string
    t.column "published",         :boolean,  :default => true
    t.column "type",              :string
    t.column "short_text",        :text
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.column "issued",     :integer
    t.column "lifetime",   :integer
    t.column "handle",     :string
    t.column "assoc_type", :string
    t.column "server_url", :binary
    t.column "secret",     :binary
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.column "timestamp",  :integer,                 :null => false
    t.column "server_url", :string
    t.column "salt",       :string,  :default => "", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
    t.column "openid_url", :string
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.column "tag_id",        :integer
    t.column "taggable_id",   :integer
    t.column "taggable_type", :string
    t.column "created_at",    :datetime
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.column "name", :string
  end

  create_table "users", :force => true do |t|
    t.column "openid_url", :string
    t.column "permission", :string
  end

end
