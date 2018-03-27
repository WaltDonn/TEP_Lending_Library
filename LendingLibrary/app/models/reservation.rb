class Reservation < ApplicationRecord
    validates_date :start_date
    validates_date :start_date, on_or_after: Date.current, :on => :create
    validates_date :end_date, on_or_after: :start_date
    validates_date :pick_up_date, on_or_after: :start_date
    validates_date :return_date, on_or_after: :pick_up_date
    # FIXME
    # validates_presence_of :release_form_id
    validates_numericality_of :release_form_id, :allow_blank => true, :only_integer => true, :greater_than_or_equal_to => 1
    validates_presence_of :kit_id
    validates_presence_of :teacher_id
    validates :returned, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validates :picked_up, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validate :only_one_open, :on => :create
    validate :checkout_present
    validate :checkin_present_and_returned
    validate :valid_renter
    validate :available_kit, on: :create
    validate :cant_return_before_pickup


    belongs_to :kit
    belongs_to :teacher,   :class_name => 'User'



    scope :open_reservations,     -> { where(returned: false) }
    scope :get_month,             ->(month){where('extract(month from pick_up_date) = ?', month)}
    scope :returning_today,       -> { where(return_date: Date.current)}
    scope :picking_up_today,      -> { where(pick_up_date: Date.current)}

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

    def cant_return_before_pickup
        if(self.returned == true)
            if(self.picked_up == false)
                 errors.add(:returned, 'Cant return before pickup')
                 return false
            end
            return true
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


    def only_one_open
        if(self.teacher == nil)
            errors.add(:teacher_id, "Teacher not present")
            return false
        end
        check = self.teacher.owned_reservations.select{|r| r.returned == false && r.id != self.id}
        if(check.size > 0)
            errors.add(:teacher_id, "Teacher already has outstanding reservations")
            return false
        end
        return true
    end

end
