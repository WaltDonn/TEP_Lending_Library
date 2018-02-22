class Kit < ApplicationRecord
    validates_presence_of :location
    has_many :items
    has_many :reservations
    
end
