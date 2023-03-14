Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :dashboards, only: [] do
    collection do
      get 'matches'
      get 'suggestions'
      get 'favprofils'
      get 'messages'
      get 'project'
      get 'like'
      get 'reject'
      get 'filtered_suggestions'
    end
  end

 get "selections", to: "pages#selections", as: :selections

  resources :selections, only: :show do
    resources :messages, only: :create

    member do
      get "/is_typing", to: "selections#is_typing"
    end
  end

  resources :users, only: :show

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
