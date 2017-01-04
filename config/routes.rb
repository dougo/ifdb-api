Rails.application.routes.draw do
  resources :games, only: :show
  jsonapi_resources :users
  get 'schemas/*resource', to: 'schemas#show', as: :schema
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
