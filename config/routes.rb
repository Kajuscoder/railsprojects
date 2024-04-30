Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  get "up" => "rails/health#show", as: :rails_health_check
  get 'home/addfriend'
  get 'home/friendlist'
  get 'home/acceptfriend'
  get 'home/deletefriend'
end
