class SwitchCommentsToPolymorhpic < ActiveRecord::Migration
  def self.up
    add_column :comments, :item_id, :integer
    add_column :comments, :item_type, :string
    remove_column :comments, :snippet_id
  end

  def self.down
    remove_column :comments, :item_id
    remove_column :comments, :item_type
    add_column :comments, :snippet_id, :integer
  end
end
