Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "events#index"
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  resources :users, only: [:show] 
  resources :events do
    get 'view_user', on: :member
  end
  resources :registrations, only: [:create, :destroy]
  resources :chatrooms, only: [:show, :index]
  resources :messages, only: [:create]
end
