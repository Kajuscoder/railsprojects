Rails.application.routes.draw do
  resources :posts
  devise_for :users
  root 'home#index'
  get "up" => "rails/health#show", as: :rails_health_check
  get 'home/addfriend'
  get 'home/friendlist'
  get 'home/acceptfriend'
  get 'home/deletefriend'
  get 'home/timeline'
end
