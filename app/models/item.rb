class Item < ActiveRecord::Base
  has_many :comments, :as => :item
  acts_as_taggable
  def self.class_methods
    [Tweet, Article]
  end
  
  def self.search(phrase)
    find(:all, :conditions => ["text LIKE ?", '%'+phrase+'%'], :order => 'created_at DESC')
  end
  
  def self.find(*args)
    if User.is_admin?
      super
    else
      with_scope(:find => {:conditions => "published != FALSE"}) do
        super
      end
    end
  end
end
