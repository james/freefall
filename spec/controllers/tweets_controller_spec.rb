require File.dirname(__FILE__) + '/../spec_helper'

describe "Tweets Controller when not admin" do
  controller_name "tweets"
  before(:all) do
    
  end

  it "should not allow access to admin unless admin" do
    controller.should be_an_instance_of(TweetsController)
  end

end
