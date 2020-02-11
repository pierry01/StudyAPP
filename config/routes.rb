Rails.application.routes.draw do
  root to: 'movies#index'
  
  devise_for :admins
  devise_for :users

  resources :movies, only: [:new, :create, :show, :index]
end
