class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
			t.column :openid_url, :string
			t.column :permission, :string
    end
  end

  def self.down
    drop_table :users
  end
end
