Rails.application.routes.draw do
  root 'root#index'
  jsonapi_resources :games
  jsonapi_resources :members
  jsonapi_resources :club_memberships
  jsonapi_resources :clubs
  get 'schemas/*resource', to: 'schemas#show', as: :schema
end
