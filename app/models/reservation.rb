class Reservation < ApplicationRecord
    validates_date :start_date
    validates_date :start_date, on_or_after: Date.current, :on => :create
    validates_date :end_date, on_or_after: :start_date
    validates_date :pick_up_date, on_or_after: :start_date
    validates_date :return_date, on_or_after: :pick_up_date

    validates_numericality_of :release_form_id, :only_integer => true, :greater_than_or_equal_to => 1, :allow_nil => true
    validates_presence_of :kit_id
    validates_presence_of :teacher_id
    validates :returned, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validates :picked_up, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validate :only_one_open, :on => :create
    validate :checkout_present
    validate :checkin_present_and_returned
    validate :valid_renter
    validate :cant_return_before_pickup
    validate :release_form_signed
    validate :kit_marked_reserved
    validate :kit_rentable, on: :create
    
    
    
    belongs_to :kit
    belongs_to :teacher,   :class_name => 'User'
    has_one :school,    :through => :teacher



    scope :open_reservations,     -> { where(returned: false) }

    scope :get_month,             ->(month){where("cast(strftime('%m', pick_up_date) as int) = ?", month)}
    scope :returning_today,       -> { where("picked_up == ? AND returned == ? AND return_date == ?", true, false, Date.current)}
    scope :picking_up_today,      -> { where("picked_up == ? AND pick_up_date == ?", false, Date.current) }


    def past_due?
        Date.current > self.end_date && self.returned == false
    end

    def self.kit_history
        group_by_month(:start_date, format: "%b", last: 12, current: true).sum("kit_id")
    end

    def self.teacher_rental_hist
        group_by_month(:start_date, format: "%b", last: 12, current: true).sum("teacher_id")
    end
    
    def self.school_rental_hist
        joins(:teacher).group_by_month(:start_date, format: "%b", last: 12, current: true).count("school_id")
    end


    private
    def kit_rentable
        if(self.kit == nil)
             errors.add(:kit_id, 'Kit should be present')
             return false
        end
        
        if(self.kit.rentable == false)
             errors.add(:kit, 'Kit should be rentable')
             return false
        end
    end
    
    
    def kit_marked_reserved
        if(self.kit.nil?)
            errors.add(:kit, 'Kit should be set')
            return false
        end
        
        if(self.picked_up == true && self.returned == false)
            #Kit still out
            if(self.kit.reserved == false)
                errors.add(:kit, 'Kit should be marked as reserved as the kit has not been returned yet')
                return false
            end
        end
        
        
        other_res = self.kit.reservations.get_month(self.start_date.month)
        
        if(other_res.select{|r| r.id != self.id}.size > 0)
             errors.add(:kit, 'Kit should only be in 1 reservation a month')
             return false
        end
        
    end
        

    
    def release_form_signed
        if(self.picked_up == true)
            if(self.release_form_id.nil?)
                 errors.add(:release_form_id, 'Release form should be present if item picked up')
                return false
            end
            return true
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
