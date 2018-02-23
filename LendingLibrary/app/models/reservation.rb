class Reservation < ApplicationRecord
    validates_date :start_date
    validates_date :end_date
    validates_date :end_date, on_or_after: :start_date
    validates_date :pick_up_date, on_or_after: :start_date
    validates_date :return_date, on_or_after: :pick_up_date
    
    validates_presence_of :release_form_id
    validates_presence_of :kit_id
    validates_presence_of :user_id
    validates :returned, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validate :only_one_open

    belongs_to :kit
    belongs_to :user


    def past_due?
        Date.current > self.end_date && self.returned == false
    end
    
    private
    def only_one_open
        check = self.user.reservations.map{|r| r.returned}.inject{|r1, r2| r1 && r2}
        if(check == false)
            errors.add(:start_date, "User already has outstanding reservations")
            return false
        end
        return true
    end

end
