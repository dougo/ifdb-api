Rails.application.routes.draw do
  resources :games, only: :show
  jsonapi_resources :users
  resources :schemas, param: :resource, only: :show
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
