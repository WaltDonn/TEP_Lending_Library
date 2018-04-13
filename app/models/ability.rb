class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    
    if(user.nil?)
      user = User.new
    end
    
    if user.has_role? :admin
        can :manage, :all
    elsif user.has_role? :manager
        can :dashboard,      Dashboard
        can :upload_users,   Home
        can :create_users,   Home
        can :upload_schools, Home
        can :create_schools, Home
        can :reports,        Home
        can :gen_reports,    Home
        can :crud,           Item
        can :crud,           Kit

        can :crud,           School
        can :crud,           User
        can :rental_history, User



        

        
    
        can :read, Reservation
        can :show, Reservation
        can :create, Reservation
        can :edit, Reservation do |r|  
          r.teacher_id == user.id
        end
        can :update, Reservation do |r|  
          r.teacher_id == user.id
        end
        
        can :returns, Reservation
        can :pickup, Reservation

        
    elsif user.has_role? :volunteer
        can :returns, Reservation
        can :pickup, Reservation
        
        can :read, Kit
        can :show, Kit
    
    elsif user.has_role? :teacher
      can :show, User do |u|  
        u.id == user.id
      end
     
      can :update, User do |u|  
        u.id == user.id
      end
      
      can :crud, Reservation do |r|
        r.teacher_id == user.id
      end
    end
    
  end
end
