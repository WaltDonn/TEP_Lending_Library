class Kit < ApplicationRecord
    validates_presence_of :location
    has_many :items
    has_many :reservations
    
    scope :available_kits,     -> { where(blackout: false, is_active: true) }
    
    
    def self.blackout_all
        Kit.all.map{|kit| kit.blackout = true 
                          kit.save!}
    end
    
    def self.lightup_all
        Kit.all.map{|kit| kit.blackout = false
                          kit.save!}
    end
    
end
