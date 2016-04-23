Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resources :settings

  # Internal API routes
  namespace :api do
    resources :weather_memes do
      get 'search', on: :collection
    end
  end

  devise_for :users

  get 'profile' => 'users#profile'
  get 'memes/manage' => 'meme_images#manage'
  get 'memes/vote' => 'meme_images#vote', as: :vote_memes
  get 'memes/fetch_images' => 'meme_images#fetch_images', as: :fetch_memes
  post 'memes/fetch_more' => 'meme_images#fetch_more'
  get 'memes/search' => 'meme_images#search'
  put 'memes/:id/vote_up' => 'meme_images#vote_up'
  put 'memes/:id/vote_down' => 'meme_images#vote_down'


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
