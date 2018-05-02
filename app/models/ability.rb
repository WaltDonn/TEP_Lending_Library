class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :select_dates, :choose_dates, :select_dates, to: :rent_kit
    alias_action :edit_check_in, :check_in_finish, :volunteer_portal, :returns, :pickup, :picked_up, :returned, to: :volunteer_actions

    if(user.nil?)
      user = User.new
    end
    
    if user.has_role? :admin
        can :manage, :all
    elsif user.has_role? :manager
        can :crud,                 Component
        can :index,                :Components
        can :dashboard,            :Dashboard
        can :upload_users,         :Home
        can :create_users,         :Home
        can :upload_schools,       :Home
        can :create_schools,       :Home
        can :reports,              :Home
        can :gen_reports,          :Home
        can :crud,                 Item
        can :index,                :Items
        can :crud,                 Kit
        can :index,                :Kits
        can :crud,                 Reservation
        can :index,                :Reservations
        can :rental_calendar,      :Reservation
        can :submit_user_details,  :Reservation
        can :edit_user_details,    :Reservation
        can :confirm_user_details, :Reservation
        can :rent_kit,             :Reservation
        can :volunteer_actions,    :Reservation
        can :manager_create,       Reservation
        can :manager_new,          Reservation
        can :crud,                 School
        can :index,                :School
        can :crud,                 User
        can :index,                :Users
        can :rental_history,       User
        

        
    elsif user.has_role? :volunteer
        can :volunteer_actions,    :Reservation
        can :show,                 Kit
    
    elsif user.has_role? :teacher
        can :show,                 User do |u|  
          u.id == user.id
        end
        can :update,               User do |u|  
          u.id == user.id
        end
        can :rent_kit,             :Reservation
        can :create,               Reservation
        can :new,                  Reservation
        can :delete,               Reservation
        can :destroy,              Reservation

        can :rental_history,       User

        can :submit_user_details,  user do |u|
          u.id == user.id
        end
        can :edit_user_details,    user do |u|
          u.id == user.id
        end
        can :confirm_user_details, user do |u|
          u.id == user.id
        end
    end
    
  end
end
