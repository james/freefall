require File.dirname(__FILE__) + '/../spec_helper'

describe Tweet do
  before(:each) do
    @tweet = Tweet.new
  end

  it "should be valid" do
     @tweet.should be_valid
  end
end

describe "A tweet that end in a dot" do
  before(:each) do
    @tweet = Tweet.new(:text => 'ends in a full stop.')
    @tweet.save!
  end
  
  it "should be set as published" do
    @tweet.published.should == true
  end
  
  it "published status should be able to be overwritten" do
    @tweet.published = false
    @tweet.save!
    @tweet.published.should == false
  end
end

describe "A tweet that doesn't end in a dot" do
  before(:each) do
    @tweet = Tweet.new(:text => 'doesnt ends in a full stop')
    @tweet.save!
  end
  
  it "should be set as not published" do
    @tweet.published.should == false
  end
  
  it "published status should be able to be overwritten" do
    @tweet.published = true
    @tweet.save!
    @tweet.published.should == true
  end
end