class ItemCategory < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :description
    validates :name, uniqueness: true

   
    mount_uploader :item_photo, ItemPhotoUploader
    
    has_many :items
    
    def one_components_group
        self.items.first.components
    end
    
    def destroy
        errors.add(:id, "Cannot destroy item category")
        return false
    end
    
    
end
