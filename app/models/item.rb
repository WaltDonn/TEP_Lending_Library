class Item < ApplicationRecord
    validates_presence_of :readable_id, uniqueness: { case_sensitive: false}
    validates_presence_of :item_category_id
    validates :condition, inclusion: { in: %w[Broken Good], message: "is not a recognized condition in system" }
    validate :item_component_condition
    has_many :components


    CONDITIONS = ['Broken','Good']

    
    scope :available_for_kits, -> { where(condition: "Good", is_active: true, kit_id: nil) }
    scope :has_kit, -> { where.not(kit_id: nil) }
    scope :broken, -> { where(condition: "Broken") }
    scope :good, -> { where(condition: "Good") }
    scope :by_readable_id,      ->(readableid) { where('readable_id = ?', readableid)}


    # scope :popular, -> { order('kit.reservations.size') }
    scope :by_read_id, -> { order('readable_id') }

    #Relationships
    belongs_to :kit, optional: true
    belongs_to :item_category
    accepts_nested_attributes_for :item_category
    accepts_nested_attributes_for :components


    def destroy
        errors.add(:id, "Cannot destroy item")
        return false
    end

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
