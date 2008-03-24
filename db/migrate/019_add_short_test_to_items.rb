class AddShortTestToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :short_text, :text
  end

  def self.down
    remove_column :items, :short_text
  end
end
