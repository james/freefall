class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
			t.column :content, :text
			t.column :snippet_id, :integer
    end
  end

  def self.down
    drop_table :articles
  end
end
