class Component < ApplicationRecord
    validates_numericality_of :max_quantity, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :damaged, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :missing, :only_integer => true, :greater_than_or_equal_to => 0
    validates :consumable, inclusion: { in: [ true, false ] }
    validates_prescence_of :item_id
    validates_prescence_of :component_category_id
    
    belongs_to :component_category
    belongs_to :item
    
    def good_condition
        if(missing > 0 OR damaged > 0){
            return true
        }
        else{
            return false
        }
    end
    
end
