class School < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :street_1
    validates_presence_of :city
    validates_presence_of :state
    validates_presence_of :zip
    validates_format_of :zip, :with => /\A\d{5}\Z/, :message => 'Zip code should be a 5 digit zip'

    #Relationships
    has_many :users

    # Callbacks
    before_destroy false

    scope :alphabetical, -> { order('name') }
    scope :active, -> { where(is_active: true) }
    scope :inactive, -> { where.not(is_active: true) }

end
