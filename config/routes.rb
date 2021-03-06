Rails.application.routes.draw do
  get 'oauths/oauth'

  get 'oauths/callback'

  get 'user_sessions/new'

  get 'user_sessions/create'

  get 'user_sessions/destroy'

  resources :users do
    resources :contacts do
      resources :notes
    end
  end


  # Routes for adding contacts and pushing user information
  get '/users/:id/select_push_fields', to: 'users#select_push_fields', as: :select_push_fields
  post '/users/:id/push', to: 'users#push', as: :push_info
  get '/users/:id/:tag', to: 'users#filter_push_contacts'
  post '/addcontact/users/:user_id/:contact_id', to: 'users#add_contact'


  # Sorcery login routes
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
  resources :user_sessions, only: [:new, :create, :destroy]


  # This is for fetching stuff from google
  post 'import', to: 'import#authenticate', as: :import
  get "oauth/contacts" => "import#authorise", :as => :googleauth #this is the callback url for the API, to set up in the api


  #This is for 3rd party authorization
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider


  # Root to index and index is redirected to login if user is not logged in
  root to: 'users#index'


  

  # get "/oauth2callback/google" => "oauths#oauth"


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
