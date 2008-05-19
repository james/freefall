ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.home '', :controller => 'items'
  map.error 'error', :controller => 'items', :action => 'error'
  map.admin '/admin', :controller => 'items', :action => 'admin'
  map.resources :items
  
  map.resources :articles, :member => {:show => :any, :hide => :any} do |article|
    article.resources :comments, :collection => {:preview => :any}
  end
  map.resources :tweets, :member => {:unhide => :any, :hide => :any}
  
  map.open_id_complete 'sessions', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.resources :sessions
end
