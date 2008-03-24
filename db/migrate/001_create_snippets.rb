class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.column :title, :string
      t.column :created_at, :datetime
      t.column :text, :text
			t.column :url, :string
			t.column :type_id, :integer
    end
  end

  def self.down
    drop_table :snippets
  end
end
