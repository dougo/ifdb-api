Rails.application.routes.draw do
  root 'root#index'
  jsonapi_resources :games
  jsonapi_resources :members
  get 'schemas/*resource', to: 'schemas#show', as: :schema
end
