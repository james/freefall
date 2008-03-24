class AddAuthToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :auth, :string
  end

  def self.down
    remove_column :comments, :auth
  end
end
