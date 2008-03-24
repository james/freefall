class ExpandSessions < ActiveRecord::Migration
  def self.up
    add_column :sessions, :openid_url, :string
  end

  def self.down
    remove_column :sessions, :openid_url
  end
end
