class Reservation < ApplicationRecord
    validates_date :start_date, on_or_after: Date.current, :on => :create
    validates_date :end_date, on_or_after: :start_date
    validates_date :pick_up_date, on_or_after: :start_date
    validates_date :return_date, on_or_after: :pick_up_date
    validates_presence_of :release_form_id
    validates_presence_of :kit_id
    validates_presence_of :teacher_id
    validates :returned, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validates :picked_up, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validate :only_one_open
    validate :is_volunteer
    validate :valid_renter
    validate :volunteer_present_and_returned
    validate :available_kit
    

    belongs_to :kit
    belongs_to :teacher,   :class_name => 'User'
    belongs_to :user_check_in, :class_name => 'User', optional: true
    belongs_to :user_check_out, :class_name => 'User'
    
    scope :open_reservations,     -> { where(returned: false) }
    scope :returning_today,       -> { where(return_date: Date.current)}


    def past_due?
        Date.current > self.end_date && self.returned == false
    end
    
    private
    def available_kit
        if(self.kit == nil)
             errors.add(:kit_id, 'Kit should be present')
             return false
        end
        if(self.kit.is_active == false)
            errors.add(:kit_id, 'Kit should be active')
            return false
        end
        if(self.kit.blackout == true)
            errors.add(:kit_id, 'Kit is currently not available')
            return false
        end
        
        
        return true
    end
    
    def checkout_present
        if(self.picked_up == false)
            return true
        end
        if(self.user_check_out == nil)
            errors.add(:user_check_out, 'Check-out user should be present if kit picked up')
            return false
        end
        if(self.user_check_out.can_checkin == false)
            errors.add(:user_check_out, 'User should be able to check out items')
            return false
        end
        return true
    end
    
    
    def checkin_present_and_returned
        if(self.returned == false)
            return true
        end
        if(self.user_check_in == nil)
            errors.add(:user_check_in, 'Check-in user should be present if kit returned')
            return false
        end
        if(self.user_check_in.can_checkin == false)
            errors.add(:user_check_in, 'User should be able to checkin items')
            return false
        end
        return true
    end
    
    
    def valid_renter
        if(self.teacher_id == nil)
            return false
        end
        checkid = self.teacher_id
		unless (User.where(id: checkid).present?) 
			errors.add(:is_active, 'Teacher is not present')
			return false
		end
		checkTeacher = User.find(checkid)
		unless checkTeacher.can_rent
			errors.add(:is_active,'Needs to be an active Teacher')
			return false
		end
		return true
    end
    
    
    def is_volunteer
        if(self.volunteer_id == nil)
            return true
        end
        checkid = self.volunteer_id
		unless (User.where(id: checkid).present?) 
			errors.add(:is_active, 'Volunteer is not present')
			return false
		end
		checkVolunteer = User.find(checkid)
		unless checkVolunteer.can_checkin
			errors.add(:is_active,'Needs to be an active Volunteer or Employee')
			return false
		end
		return true
    end
    
    def only_one_open
        check = self.teacher.owned_reservations.select{|r| r.returned == false}
        if(check.size > 1)
            errors.add(:start_date, "Teacher already has outstanding reservations")
            return false
        end
        return true
    end

end
