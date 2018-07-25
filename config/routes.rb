Rails.application.routes.draw do
  get 'events/index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "events#index"
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  resources :users, only: [:show] 
  resources :events, only: [:show, :index]
  resources :registrations, only: [:create, :destroy]
end
