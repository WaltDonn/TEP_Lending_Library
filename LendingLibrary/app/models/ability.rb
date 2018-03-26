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
        can :crud, ComponentCategory
        can :crud, Component
        can :crud, Kit
        can :crud, ItemCategory
        can :crud, Item
        #can :crud, Report
        can :crud, Reservation
        can :crud, School
        
        can :read, User
        can :show, User

        
    elsif user.has_role? :volunteer
        can :returns, Reservation
        can :pickup, Reservation
    
    elsif user.has_role? :teacher
      can :show, User do |u|  
        u.id == user.id
      end
     
      can :update, User do |u|  
        u.id == user.id
      end
      
      can :crud, Reservation do |r|
        r.user_id == user.id
      end
      
      
    else
      can :read, Kit
    end
    
  end
end
