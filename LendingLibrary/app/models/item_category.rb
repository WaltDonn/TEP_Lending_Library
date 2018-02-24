class ItemCategory < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :description
    validates :name, uniqueness: true

    validates_numericality_of :inventory_level, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :amount_available, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => :inventory_level
    
    mount_uploader :item_photo, ItemPhotoUploader
    
    has_many :items
    
    def more_available
       if(self.amount_available == nil)
           return false
       end
       self.amount_available > 0
    end
    
    
end
