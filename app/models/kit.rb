class Kit < ApplicationRecord
    validates_presence_of :location, uniqueness: { case_sensitive: false}
    validates :reserved, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validates :is_active, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    
    has_many :items
    has_many :reservations
    has_one :item_category, :through => :items
    accepts_nested_attributes_for :items
    accepts_nested_attributes_for :item_category
    
    scope :visible_kits,     -> { where(blackout: false, is_active: true, reserved: false) }
    scope :by_location,      ->(location) { where('location = ?', location)}
    
    
    def self.available_kits
        return Kit.all.select{|k| k.rentable && k.reserved == false && k.items.size > 0}
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
        full_list = kits.map{|k| unless k.items.nil? || k.items.first.nil?
                                    k.items.first.item_category
                                else
                                    nil
                                end}

        return full_list.compact.uniq
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
        if self.items.size > 0 && !self.items.first.item_category.nil?
            self.items.first.item_category.item_photo
        else
            nil
        end
    end

    def name
        if self.items.size > 0 && !self.items.first.item_category.nil?
            self.items.first.item_category.name
        else
            nil
        end
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
    
    def destroy
        errors.add(:id, "Cannot destroy kit")
        return false
    end
    
end
