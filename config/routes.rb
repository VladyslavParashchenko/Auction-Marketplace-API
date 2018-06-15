# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  get '/lots/my', to: 'lots#my_lots'
  resources :lots do
    resources :bids, only: [:show, :create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
