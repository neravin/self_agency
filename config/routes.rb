Rails.application.routes.draw do
  get 'admin' => 'admin_routes#index'
  controller :sessions_admin do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get 'admin_routes/index'
  get 'sessions_admin/new'
  get 'sessions_admin/create'
  get 'sessions_admin/destroy'
  get 'home/index'

  resources :home, only: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:create,:edit, :update]
  resources :clients, only: [:create, :index, :show, :edit, :destroy] do
    collection do
      post 'select_category'
      patch 'edit_specializations'
      get 'specialization'
      get 'more_info'
    end
  end
  resources :offer_services
  resources :admin_routes
  resources :queues
  resources :activation_client, only: [:edit, :update]
  resources :advertisements, only: [:create, :index, :update] do
    collection do
      patch 'perform_ad'
      patch 'worker_cancel'
    end
  end

  resources :admins
  resources :services
  resources :categories
  resources :workers, only: [:create, :index, :update] do
    collection do
      patch 'worker_ad'
    end
  end
  
  resources :reviews, only: [:create]

  match '/signin', to: 'sessions#new', via: 'get'
  match '/registration', to: 'clients#new' , via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/perform_ad' => 'advertisements#perform_ad', via: 'get'
  match '/select_category' => 'clients#select_category', via: 'post'
  match '/worker_ad' => 'workers#worker_ad', via: 'get'
  match '/worker_cancel' => 'advertisements#worker_cancel', via: 'get'
  match 'edit_specializations' => 'clients#edit_specializations', via: 'patch'

  match '/announcement_delete/:id', to: 'advertisements#destroy', via: 'delete'
  match '/announcement_update/:id' => 'advertisements#update', via: 'patch'

  root to: 'home#index', as: ''

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
