class ItemsController < ApplicationController
  make_resourceful do 
    build :show
  end
  def index
    if params[:search].blank?
      @items = Item.find(:all, :order => 'created_at DESC', :limit => 30)
    else
      @items = Item.search(params[:search])
    end
  end
  
  def error
    render :text => preview_article_comments_path(1)
  end
end
