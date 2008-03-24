class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.column :created_at, :datetime
      t.column :text, :string
      t.column :source, :string
      t.column :snippet_id, :integer
      t.column :published, :boolean, :default => false
      t.column :published_by_hand, :boolean, :default => false
    end
  end

  def self.down
    drop_table :tweets
  end
end
