require File.dirname(__FILE__) + '/../spec_helper'

describe "A post to preview an article comment" do
  controller_name :comments
  
  before(:each) do
    @article = Article.create!(:text => "An article")
    post 'preview', {:article_id => @article.id}
    @comment = assigns[:comment]
  end
  
  it "should work" do
    response.should be_success
  end
  
  it "should have set the item_id correctly" do
    @comment.item.should == @article
  end
end

describe "A post to create an article comment" do
  controller_name :comments
  
  before(:each) do
    @article = Article.create!(:text => "An article")
    post 'create', {:article_id => @article.id}
    @comment = assigns[:comment]
  end
  
  it "should work" do
    response.response_code.should == 302
  end
  
  it "should have set the item_id correctly" do
    @comment.item.should == @article
  end
end
