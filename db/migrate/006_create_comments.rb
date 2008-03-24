class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
			t.column :snippet_id, :integer
			t.column :content, :text
			t.column :openid_url, :string
			t.column :name, :string
			t.column :email, :string
			t.column :url, :string
    end
  end

  def self.down
    drop_table :comments
  end
end
