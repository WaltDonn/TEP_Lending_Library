Rails.application.routes.draw do
  resources :users
  resources :components
  resources :items
  resources :item_categories
  resources :component_categories
  resources :reservations
  resources :kits
  resources :schools
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
