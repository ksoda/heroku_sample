# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :todos do
    resources :items
  end
  resource :authentication, only: %i[create destroy]
  resources :users, only: %i[create show]
end
