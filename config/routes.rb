Rails.application.routes.draw do

  use_doorkeeper
  devise_for :users, skip: :registrations
  # Set the root url
  root :to => 'home#home'

  get 'errors/not_found'
  get 'errors/internal_server_error'


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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'returns' => 'reservations#returns', as: :returns
  get 'pickup' => 'reservations#pickup', as: :pickup
  get 'rental_calendar/:month' => 'reservations#rental_calendar', as: :rental_calendar
  get 'users/:id/rental_calendar' => 'users#rental_calendar', as: :personal_rentals
  get 'users/:id/rental_history' => 'users#rental_history', as: :rental_history
  get 'users/:id/confirmation' => 'users#confirmation', as: :user_info_confirmation
  get 'users/:id/reservation_user_edit' => 'users#reservation_user_edit', as: :reservation_user_edit
  get 'steamkits' => 'item_categories#index', as: :shopping
  get 'rental_dates' => 'reservations#rental_dates', as: :rental_dates
  post 'reservations/select_dates' => 'reservations#select_dates', as: :reservation_select_dates

  get '/' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  # get 'home/upload_users'
  get 'upload_users' => 'home#upload_users', as: :upload_users
  post 'create_users' => 'home#create_users', as: :create_users
  # get 'home/upload_schools'
  get 'upload_schools' => 'home#upload_schools', as: :upload_schools
  post 'create_schools' => 'home#create_schools', as: :create_schools

  namespace :api do
    namespace :v1 do
      get '/resource_owner' => "credentials#resource_owner"
    end
  end



  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  get '*a', to: 'errors#routing'

end
