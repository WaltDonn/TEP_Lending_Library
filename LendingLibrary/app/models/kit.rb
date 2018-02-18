class Kit < ApplicationRecord
    validates_prescence_of :location
    has_many :items
    
end
