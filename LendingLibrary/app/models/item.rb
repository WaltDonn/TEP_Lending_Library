class Item < ApplicationRecord
    validates_prescence_of :readable_id
    validates_prescence_of :category_id
    validates :condition, inclusion: { in: %w[Broken Good], message: "is not a recognized condition in system" }
    validate :item_component_condition
    has_many :components
    
    
    CONDITIONS = [['Broken', :broken],['Good', :good]]
    
    
    #Relationships
    belongs_to :kit
    belongs_to :item_category
    
    def item_component_condition
        if(self.condition == "Good"){
            self.components.map{|comp| comp.good_condition}.inject{|comp1, comp2| comp1 AND comp2} == true
        }
    end

end
