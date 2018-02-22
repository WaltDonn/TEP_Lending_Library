class Reservation < ApplicationRecord
    validates_date :start_date
    validates_date :end_date
    validates_date :pick_up_date, on_or_after: :start_date
    validates_date :return_date, on_or_after: :pick_up_date
    validates_presence_of :release_form_id
    validates_presence_of :kit_id
    validates_presence_of :user_id
    validates :returned, inclusion: { in: [ true, false ] }
    
    
    belongs_to :kit
    belongs_to :teacher
    
    
    def past_due?
        date.current > :end_date && :returned == false
    end
    
end
