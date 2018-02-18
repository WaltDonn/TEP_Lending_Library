class ComponentCategory < ApplicationRecord
     validates_prescence_of :name
     validates_prescence_of :description
     
     has_many :components
     
end
