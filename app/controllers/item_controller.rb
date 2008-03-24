class ItemController < ApplicationController
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
