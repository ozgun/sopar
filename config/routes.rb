ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Login
  map.connect 'login', :controller => 'accounts', :action => 'login'
  map.connect 'logout', :controller => 'accounts', :action => 'logout'

  map.namespace :admin do |admin|
    admin.resources :site_prefs, :collection => {:delete_logo => :get}
    admin.resources :users, :member => { :update_password => :put },
                            :has_many => [:articles]
    admin.resources :pages, :member => {:publish => :get, :unpublish => :get}
    admin.resources :categories
    admin.resources :articles, :member => {:publish => :get, :unpublish => :get},
                               :has_many => [:comments]
    admin.resources :comments, :member => {:publish => :get, :unpublish => :get}
    admin.resources :projects
    admin.resources :assets
    admin.resources :tags, :collection => {:search => :get}
   end



  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
