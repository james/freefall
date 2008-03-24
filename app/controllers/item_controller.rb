class ItemController < ApplicationController
  before_filter :check_admin, :except => [:index, :show]
  make_resourceful do 
    build :all
    response_for :edit do
      render 'item/edit'
    end
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
