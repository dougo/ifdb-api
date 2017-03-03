Rails.application.routes.draw do
  jsonapi_resources :games
  jsonapi_resources :members
  get 'schemas/*resource', to: 'schemas#show', as: :schema
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
