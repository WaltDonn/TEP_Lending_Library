class ComponentCategory < ApplicationRecord
     validates_presence_of :name
     validates_presence_of :description
     
     has_many :components
     
end
