class CommentsController < ApplicationController
  
  before_filter :check_admin, :only => [:index, :edit, :update, :destroy]
  before_filter :find_item, :except     => [:index, :edit, :update, :destroy]
  
  make_resourceful do 
    build :all
    
    before :create do
      @comment.item = @item
      auth_openid
      if current_object.is_spam?(request)
        render :text => "Oh dear, I've been told this is SPAM. Sorry if this ain't true" and return
      end
    end
    
    response_for :create do
      flash[:notice] = "Thank you for your comment"
      redirect_to url_for_item(@item)
    end
    
    response_for :destroy do
      redirect_to comments_path
    end
  end
  
  def preview
    auth_openid
    @comment = Comment.new(params[:comment])
    @comment.item = @item
    if session[:openid_reg]
      @comment.name = session[:openid_reg]['fullname']
    end
  end
  
  protected
  
  def find_item
    @item = Item.find(params[:article_id])
  end
  
  def auth_openid
    if session[:comment]
      params[:comment] = session[:comment]
      session[:comment] = nil
    end
    if params[:comment] && params[:comment][:auth] == 'openid' && params[:comment][:openid_url] != session[:openid_url]
      session[:comment] = params[:comment]
      authenticate_with_open_id(params[:comment][:openid_url], :required => [ :fullname ], :optional => [:email, :nickname, :dob, :gender, :postcode, :country, :language, :timezone]) do |result, identity_url, registration|
        if result.successful?
          session[:openid_url] = params[:comment][:openid_url]
          session[:openid_reg] = registration
        else
          flash[:notice] = "OpenID authentication for #{identity_url} was unsuccessful: '#{result.message}'"
          @comment = Comment.new(params[:comment])
          @comment.item = @item
          render :action => 'preview'
        end
      end
    end
  end
end
