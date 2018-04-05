class Kit < ApplicationRecord
    validates_presence_of :location
    validates :reserved, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validates :is_active, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    
    before_destroy :is_destroyable
    
    has_many :items
    has_many :reservations
    
    scope :visible_kits,     -> { where(blackout: false, is_active: true, reserved: false) }
    
    
    def self.available_kits
        return Kit.all.select{|k| k.rentable && k.reserved == false}
    end

    def self.damaged
        kits = Kit.visible_kits
        damaged_kits = kits.select{|k| 
            size_of_bad = k.items.select{|i| i.condition == "Broken"}.size
            size_of_bad > 0
        }
        return damaged_kits
    end
    
    def self.rental_categories
        kits = Kit.available_kits
        full_list = kits.map{|k| k.items.first.item_category}
        return full_list.uniq
    end
    
    def self.available_for_item_category(rental_category)
        kits = Kit.available_kits
        kits.select{|k| k.items.first.item_category.id == rental_category.id}
    end

    def self.top_kits
        joins(:reservations).group("kits.id").order("count(kits.id) DESC").limit(5)
    end
    
    
    def rentable
        #Checks everything but self.reserved
        #self.reserved is handled by reservation model
        self.blackout == false && self.is_active == true && 
            self.items.select{|i| i.condition == "Broken"}.size == 0
    end
    
    
    
    def self.blackout_all
        Kit.all.map{|kit| kit.blackout = true 
                          kit.save!}
    end
    
    def self.lightup_all
        Kit.all.map{|kit| kit.blackout = false
                          kit.save!}
    end

    def photo
        self.items.first.item_category.item_photo
    end

    def name
        self.items.first.item_category.name
    end

    def inventory
        Kit.visible_kits.map{|kit| kit.name == self.name}.count(true)
    end
    
    def set_reserved
        self.reserved = true;
        self.save!
    end
    
    def unset_reserved
        self.reserved = false;
        self.save!
    end
    
    private
    def is_destroyable
        if(self.items.size > 0)
            errors.add(:items, "Kit still has items can't be destroyed")
            return false
        end
    end
    
end
