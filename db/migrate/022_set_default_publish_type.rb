class SetDefaultPublishType < ActiveRecord::Migration
  def self.up
    change_column :items, :published, :boolean, :default => true
  end

  def self.down
  end
end
