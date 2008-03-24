require File.dirname(__FILE__) + '/../spec_helper'

describe Item do
  before(:each) do
    @item = Item.new
  end
  
  it "published status should be able to be overwritten" do
    @item.published = false
    @item.save!
    @item.published.should == false
  end
end

describe "Finding items" do
  before(:each) do
    @published_article =    Article.create!(:published => true,  :text => "published = true")
    @unpublished_article1 = Article.create!(:published => false, :text => "published = false")
    @unpublished_article2 = Article.create!(:published => nil,   :text => "published = nil")
  end
  
  it "should find published articles" do
    Item.find(:all).should == [@published_article]
  end
  
  it "should not find unpublished articles if no admin" do
    lambda{Item.find(@unpublished_article2.id)}.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "should be able to exclude unpublished articles and except other conditions" do
    Item.find(:all, :conditions => "text LIKE '%published%'").should == [@published_article]
  end
  
  it "should find unpublished articles if admin" do
    User.stub!(:is_admin?).and_return(true)
    Item.find(:all).size.should == 3
  end
end

describe "searching items" do
  before(:each) do
    @tweet   =   Tweet.create!(:text => "This is called Jeremy yes.")
    @article = Article.create!(:text => "This is called Gerald yes.")
  end
  
  it "should search the contents of articles" do
    Item.search('Gerald').should == [@article]
  end
  
  it "should search the contents of articles case insensitively" do
    Item.search('geRald').should == [@article]
  end
  
  it "should search the contents of tweets case insensitively" do
    Item.search('jeremY').should == [@tweet]
  end
end