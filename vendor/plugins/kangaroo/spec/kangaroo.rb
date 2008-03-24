require File.dirname(__FILE__) + '/spec_helper'

describe Snippet do
	it "must create article if sent article hash to create_with_related" do
		snippet = Snippet.new
		snippet.save_with_related(:title => 'Title', :article => {:content => 'Content'})
		Snippet.find(:all).size.should == 1
		Article.find(:all).size.should == 1
		Snippet.find_by_title('Title').should_not == nil
		Article.find_by_content('Content').should_not == nil
	end
	
	it "will revert to saving nothing if sent invalid data to child model using create_with_related" do
		omgfailure
	end
	
end