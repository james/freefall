class ItemsController < ApplicationController
  make_resourceful do 
    build :index, :show
  end
  def index
    if params[:search].blank?
      @items = Item.find(:all, :order => 'created_at DESC', :limit => 30)
    else
      @items = Item.search(params[:search])
    end
  end
  
  def error
    wert
  end
end
