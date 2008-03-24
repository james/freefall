namespace :import do
  
  task :delete_all => :environment do
    Item.destroy_all
    Comment.destroy_all
  end
  
  task :articles => :environment do
    class Entry < ActiveRecord::Base
      
    end
    Entry.establish_connection(
      :host => "abscond.org",
      :database => 'arran',
      :username => 'blog_converter',
      :password => 'Temporary_password92675',
      :adapter => 'mysql'
    )
    categories = ['personal', 'geek', 'music']
    Article.transaction do
      Entry.find(:all, :conditions => ["category_id = 1 OR category_id = 2"]).each do |entry|
        article = Article.new
        article.external_id = entry.id
        article.title = entry.title
        article.short_text = entry.excerpt
        article.text = entry.content
        article.tag_list = categories[entry.category_id.to_i - 1]
        article.created_at = entry.posted_at
        article.save!
      end
    end
  end
  
  task :comments => :environment do
    class OldComment < ActiveRecord::Base
      def self.table_name
        "comments"
      end
    end
    OldComment.establish_connection(
      :host => "abscond.org",
      :database => 'arran',
      :username => 'blog_converter',
      :password => 'Temporary_password92675',
      :adapter => 'mysql'
    )
    OldComment.find(:all, :conditions => ["spam != 1"]).each do |old_comment|
      if article = Article.find_by_external_id(old_comment.entry_id)
        comment = Comment.new
        comment.content = old_comment.message
        comment.name = old_comment.name
        comment.email = old_comment.email_address
        comment.url = old_comment.url
        comment.created_at = old_comment.posted_at
        comment.auth = old_comment.auth
        comment.openid_url = old_comment.openid_url
        comment.ip = old_comment.ip
        
        
        article.comments << comment
        
        comment.save!
      end
    end
  end

end