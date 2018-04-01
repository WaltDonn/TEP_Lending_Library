Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # main resources routes
  resources :users, :except => [:new, :create, :delete, :destroy]  do
    resources :item_categories
  end
  resources :components
  resources :items
  resources :item_categories
  resources :component_categories
  resources :reservations
  resources :kits
  resources :schools
  
  # devise/sessions and signup confirmation routes
  use_doorkeeper
  devise_for :users, skip: :registrations
  get 'users/:id/confirmation' => 'users#confirmation', as: :user_info_confirmation
  
  # management routes
  get 'returns' => 'reservations#returns', as: :returns
  get 'pickup' => 'reservations#pickup', as: :pickup
  get 'dashboard' => 'dashboard#dashboard', as: :dashboard
  
  # rental/reservations routes
  get 'rental_calendar/:month' => 'reservations#rental_calendar', as: :rental_calendar
  get 'rental_dates' => 'reservations#rental_dates', as: :rental_dates
  get 'users/:id/rental_calendar' => 'users#rental_calendar', as: :personal_rentals
  get 'users/:id/rental_history' => 'users#rental_history', as: :rental_history
  get 'users/:id/reservation_user_edit' => 'users#reservation_user_edit', as: :reservation_user_edit

  # kit shopping routes
  get 'steamkits' => 'item_categories#index', as: :shopping
  post 'reservations/select_dates' => 'reservations#select_dates', as: :reservation_select_dates
  
  # static page routes
  get '/' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  
  # uploading users from a csv
  get 'upload_users' => 'home#upload_users', as: :upload_users
  post 'create_users' => 'home#create_users', as: :create_users
  
  
  namespace :api do
    namespace :v1 do
      get '/resource_owner' => "credentials#resource_owner"
    end
  end
  
  # error pages
  get 'errors/not_found'
  get 'errors/internal_server_error'
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  get '*a', to: 'errors#routing'
  
  # Set the root url
  root :to => 'home#home'

end