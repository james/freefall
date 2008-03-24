class RemoveAutoPublishFromItems < ActiveRecord::Migration
  def self.up
    remove_column :items, :auto_publish
  end

  def self.down
    add_column :items, :auto_publish, :boolean
  end
end
