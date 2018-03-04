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

  get 'returns' => 'reservation#returns', as: :returns
  get 'pickup' => 'reservation#pickup', as: :pickup
  get 'rental_calendar/:month' => 'reservation#rental_calendar', as: :rental_calendar
  
  
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'reports' => 'home#reports', as: :reports
  
end
