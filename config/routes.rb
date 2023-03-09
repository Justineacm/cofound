Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "dashboard", to: "pages#dashboard", as: :dashboard
  get "selections", to: "pages#selections", as: :selections

  resources :users, only: :show
  # do
    # member do
    #   post 'toggle_favorite', to: "users#toggle_favorite"
    #   # The generated route will look like this: users/:id/toggle_favorite
    # end
  # end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
