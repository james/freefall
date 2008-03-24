class ItemController < ApplicationController
  before_filter :check_admin
  make_resourceful do 
    build :all
  end
  def hide
    check_admin
    item = Item.find(params[:id])
    item.published = false
    item.save!
    redirect_to '/'
  end
  def show
    check_admin
    item = Item.find(params[:id])
    item.published = true
    item.save!
    redirect_to '/'
  end
end
