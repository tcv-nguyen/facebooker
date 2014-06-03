Rails.application.routes.draw do

  scope module: :api do
    get "/*query" => "facebook#process_query"
    
    # get 'facebook-friends/:facebook_user_id/:auth_token' => 'facebook#facebook_friends'
    # get 'facebook-pages/:search_term/:auth_token' => 'facebook#facebook_pages'
    # get 'facebook-checkins/:facebook_page_id/:auth_token' => 'facebook#facebook_checkins'
    # get 'facebook-checkin-pages/:facebook_user_id/:auth_token' => 'facebook#facebook_checkin_pages'
    # get 'facebook-page-likes/:facebook_page_id/:facebook_user_list/:auth_token' => 'facebook#facebook_page_likes'
    # get 'facebook-page-albums/:facebook_page_id/:auth_token' => 'facebook#facebook_page_albums'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
