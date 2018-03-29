class Component < ApplicationRecord
    validates_numericality_of :max_quantity, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :damaged, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :missing, :only_integer => true, :greater_than_or_equal_to => 0
    validates :consumable, inclusion: { in: [ true, false ] }
    validates_presence_of :item_id
    validates_presence_of :component_category_id
    validate :total_number_parts
    
    
    #Callback
    before_save :check_condition_item
    
    belongs_to :component_category
    belongs_to :item
    
    def good_condition
        if(self.missing > 0 or self.damaged > 0)
            return false
        else
            return true
        end
    end
    
    
    private
    def check_condition_item
        if(self.good_condition == false)
            self.item.condition = "Broken"
            self.item.save!
        end
    end
    
    def total_number_parts
        if(self.max_quantity == nil || self.missing == nil || self.damaged == nil)
             errors.add(:max_quantity, message: "max_quantity, missing, damaged cannot be nil")
            return false
        end
        
        if(self.max_quantity < (self.missing + self.damaged))
            errors.add(:max_quantity, message: "max_quantity, must be greater than missing and damaged")
            return false
        end
        return true
    end
    
end
