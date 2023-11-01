Rails.application.routes.draw do
  get 'customers/show'
  get 'customers/edit'
  get 'customers/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # browse routes for showing all, and individual restaurants respectively
  resources :browse, only: [:index, :show]
  root 'browse#index'
  get 'restaurants', to: 'browse#index'
  get 'restaurants/:id', to: 'browse#show', as: :restaurant

  # Defines the root path route ("/")
  # root "posts#index"
  resources :restaurants do
    resources :menu_items, only: [:index, :new, :create]
  end

  resources :restaurants do
    resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]
  end
  
  

  resources :customers, only: [:show, :edit, :update]

  resources :menu_items, only: [:show, :edit, :update, :destroy]

end
