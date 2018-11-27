# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth", controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords"
  }
  get "/lots/my", to: "lots#my_lots"
  resources :lots do
    resources :bids, only: [:show, :create]
    resources :order, only: [:create, :update]
  end
end
