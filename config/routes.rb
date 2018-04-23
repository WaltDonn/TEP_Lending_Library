Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # Set the root url
  root :to => 'home#home'
  
  # devise/sessions and signup confirmation routes

  use_doorkeeper
  devise_for :users, skip: :registrations
  get 'users/:id/confirmation' => 'users#confirmation', as: :user_info_confirmation
  
  # main resources routes
  resources :users, :except => [:new, :create, :delete, :destroy]
  resources :components, :except => [:index, :show]
  resources :items
  resources :item_categories, :except => [:index, :show]
  resources :reservations
  resources :schools, :except => [:new, :create, :delete, :destroy]
  resources :kits
  
  # management routes
  get 'returns' => 'reservations#returns', as: :returns
  get 'pickup' => 'reservations#pickup', as: :pickup
  post 'picked_up/:id' => 'reservations#picked_up', as: :picked_up
  post 'returned/:id' => 'reservations#returned', as: :returned
  get 'dashboard' => 'dashboard#dashboard', as: :dashboard
  get 'volunteer_portal' => 'reservations#volunteer_portal', as: :volunteer_portal
  get 'clean_database' => 'dashboard#clean_database', as: :clean_database
  post 'destroy_database' => 'dashboard#destroy_database', as: :destroy_database

  # rental/reservations routes
  get 'rental_calendar' => 'reservations#rental_calendar', as: :rental_calendar
  get 'rental_dates' => 'reservations#rental_dates', as: :rental_dates
  get 'users/:id/rental_history' => 'users#rental_history', as: :rental_history
  
  # kit shopping routes
  get 'steamkits' => 'kits#steamkits', as: :shopping
  get 'choose_dates' => 'reservations#choose_dates', as: :reservation_choose_dates
  post 'select_dates' => 'reservations#select_dates', as: :reservation_select_dates
  get 'available_kit/:id' => 'kits#available_kit', as: :available_kit
  get 'confirm_user_details' => 'reservations#confirm_user_details', as: :confirm_user_details
  get 'edit_user_details' => 'reservations#edit_user_details', as: :edit_user_details
  patch 'submit_user_details' => 'reservations#submit_user_details', as: :submit_user_details
  get 'reservation_error' => 'reservations#reservation_error', as: :reservation_error
  
  # new kit routes
  post 'create_item_category' => 'kits#create_item_category', as: :create_item_category
  
  # static page routes
  get '/' => 'home#home', as: :home
  
  # uploading users from a csv
  get 'upload_users' => 'home#upload_users', as: :upload_users
  post 'create_users' => 'home#create_users', as: :create_users
  
  # get 'home/upload_schools'
  get 'upload_schools' => 'home#upload_schools', as: :upload_schools
  post 'create_schools' => 'home#create_schools', as: :create_schools

  # generate reports
  get 'reports' =>  'home#reports', as: :reports
  post 'gen_reports' => 'home#gen_reports', as: :gen_reports
  
  
  namespace :api do
    namespace :v1 do
      get '/resource_owner' => "credentials#resource_owner"
    end
  end
  
  # error pages
  get 'errors/not_found'
  get 'errors/internal_server_error'
  get 'errors/access_denied'
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  match "/403", :to => "errors#access_denied", :via => :all
  get '*a', to: 'errors#not_found'
  
end