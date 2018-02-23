class ComponentCategory < ApplicationRecord
     validates_presence_of :name
     validates_presence_of :description
     validates :name, uniqueness: true
     
     has_many :components
     
end
