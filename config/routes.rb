Rails.application.routes.draw do
  get 'home/main'
  # Devise routes for User

  devise_for :users, skip: :registrations, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'customers/sign_up', to: 'customers/registrations#new', as: :new_customer_registration
    post 'customers', to: 'customers/registrations#create', as: :customer_registration
    get 'owners/sign_up', to: 'owners/registrations#new', as: :new_owner_registration
    post 'owners', to: 'owners/registrations#create', as: :owner_registration
  end

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Root route
  # root 'browse#index'
  get 'home', to: 'home#main'
  root 'home#main'

  # resources :orders do
  #   member do
  #     patch :update_status

  #   end
  # end

  resources :orders, only: [:index, :show]
  patch 'orders/:id/update_status', to: 'orders#update_status', as: :update_status



  # Browse routes
  resources :browse, only: [:index, :show, :new]
  resources :customers, only: [:show]
  get 'restaurants', to: 'browse#index'
  # get 'restaurants/new', to: 'restaurants#new'
  get 'restaurants/:id', to: 'browse#show', as: :restaurant

  # Restaurant routes with nested resources for menu_items and reviews
  resources :restaurants do
    resources :menu_items, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  # Customer routes
  resources :customers, only: [:update]
  resource :cart, only: [:show]
  get '/profile', to: 'profiles#show', as: :profile
  get '/edit_profile', to: 'profiles#edit', as: :edit_profile

  # MenuItems routes
  #resources :menu_items, only: [:show, :edit, :update, :destroy]

  # Defines the root path route ("/")
  # root "posts#index"
  resources :restaurants do
    resources :menu_items, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  get 'restaurants/:restaurant_id/customer_menu', to: 'menu_items#customer_index', as: :customer_menu
  post 'add_to_cart/:menu_item_id', to: 'cart_items#add_to_cart', as: :add_to_cart
  patch 'remove_from_cart/:menu_item_id', to: 'cart_items#remove_from_cart', as: :remove_from_cart
  get '/cartback', to: 'carts#back', as: :cart_back
  delete 'clear_cart', to: 'carts#clear_cart'

  resource :checkout, only: [:create], controller: 'checkouts' do
    collection do
      get 'success', to: 'checkouts#success'
      get 'cancel', to: 'checkouts#cancel'
    end
  end

  get 'stripe_callback', to: 'stripe#callback'

  get 'owners/confirm', to: 'owners/registrations#confirm'
  get '*path', to: redirect('/home')


end
