class ItemCategory < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :description
    validates_numericality_of :inventory_level, :only_integer => true, :greater_than_or_equal_to => 0
    validates_numericality_of :amount_available, :only_integer => true, :greater_than_or_equal_to => 0
    
    mount_uploader :item_photo, ItemPhotoUploader
    
    def more_available
        :amount_available > 0
    end
    
end
