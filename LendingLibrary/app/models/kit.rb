class Kit < ApplicationRecord
    validates_presence_of :location
    has_many :items
    has_many :reservations
    
    scope :visible_kits,     -> { where(blackout: false, is_active: true) }
    
    def available_kits
        kits = Kit.visible_kits
        actual_kits = kits.select{|k| 
            size_of_bad = k.items.select{|i| i.condition == "Broken"}
            size_of_bad == 0
        }
        return actual_kits
    end
    
    def self.blackout_all
        Kit.all.map{|kit| kit.blackout = true 
                          kit.save!}
    end
    
    def self.lightup_all
        Kit.all.map{|kit| kit.blackout = false
                          kit.save!}
    end
    
end
