class RemovePreStiTables < ActiveRecord::Migration
  def self.up
    drop_table :types
    drop_table :snippets
    drop_table :tweets
    drop_table :articles
  end

  def self.down
    create_table :articles do |t|
      t.column :content, :text
      t.column :snippet_id, :integer
    end
    
    create_table :types do |t|
      t.column :name, :string
    end
    
    create_table :snippets do |t|
      t.column :title, :string
      t.column :created_at, :datetime
      t.column :text, :text
      t.column :url, :string
      t.column :type_id, :integer
    end
    
    create_table :tweets do |t|
      t.column :created_at, :datetime
      t.column :text, :string
      t.column :source, :string
      t.column :snippet_id, :integer
      t.column :published, :boolean, :default => false
      t.column :published_by_hand, :boolean, :default => false
    end
  end
end
