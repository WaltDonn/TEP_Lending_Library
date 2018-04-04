class ItemCategory < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :description
    validates :name, uniqueness: true

   
    mount_uploader :item_photo, ItemPhotoUploader
    
    has_many :items
    
    def more_available
       if(self.amount_available == nil)
           return false
       end
       self.amount_available > 0
    end
    
    def one_components_group
        self.items.first.components
    end
    
    
end
