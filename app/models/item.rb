class Item < ApplicationRecord
    validates_presence_of :readable_id
    validates_presence_of :item_category_id
    validates :condition, inclusion: { in: %w[Broken Good], message: "is not a recognized condition in system" }
    validate :item_component_condition
    has_many :components


    CONDITIONS = [['Broken', :broken],['Good', :good]]

    
    scope :available_for_kits, -> { where(condition: "Good", is_active: true) }
    scope :broken, -> { where(condition: "Broken") }
    scope :good, -> { where(condition: "Good") }

    #Relationships
    belongs_to :kit
    belongs_to :item_category

    def item_component_condition
        if(self.condition == "Good")
            check = self.components.map{|comp| comp.good_condition}.inject{|comp1, comp2| comp1 && comp2}
            if(check == false)
                  errors.add(:condition, message: "max_quantity, must be greater than missing and damaged")
                return false
            end
        end
        return true
    end

end
