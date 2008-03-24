class AddPublisedBooleanToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :published, :boolean
    add_column :items, :auto_publish, :boolean
  end

  def self.down
    remove_column :items, :published
    remove_column :items, :auto_publish
  end
end
