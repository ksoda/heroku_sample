# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/dev')
  namespace :dev do
    root to: 'pages#home'
    get 'pages/home'
  end
  resources :todos do
    resources :items
  end
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
