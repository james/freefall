class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      #Item
      t.column :title, :string
      t.column :created_at, :datetime
      
        #Link
        t.column :url, :string
        t.column :text, :text
        
        #Tune
        t.column :artist, :string
        # text
          
          #HeartedTune
          #url
          
          #MP3
          t.column :length, :integer
        
        #Status
        # Text
          
          #Tweet
          t.column :external_id, :string
        
        #Picture
        
          #FlickrPhoto
          #url
          t.column :made_at, :datetime
          #text
          t.column :external_file_url, :string
        
        #Article
        # text
        
        #CodeSnippet
        # text
    end
  end

  def self.down
    drop_table :items
  end
end
