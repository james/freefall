class AddCreatedAtToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :created_at, :datetime
  end

  def self.down
    remove_column :comments, :created_at
  end
end
