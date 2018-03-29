class User < ApplicationRecord
#admin = User.new; admin.id = 1; admin.first_name = "Admin"; admin.last_name = "Admin"; admin.is_active = true; admin.role = "admin"; admin.email = "beebot@mailinator.com"; admin.password = "secretpassword"; admin.password_confirmation = "secretpassword"; admin.save 
#school1 = School.new; school1.id = 1; school1.name = "Some School"; school1.street_1 = "100 Learning Way"; school1.city = "Pittsburgh"; school1.state = "PA"; school1.zip = "15213"; school1.is_active = true; school1.save

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :confirmable
    
    validates_presence_of :first_name
    validates_presence_of :last_name
    validates_presence_of :role
    validates :first_name, format: {with: /\A[A-Za-z\-]+\z/, message: "Should be a valid name"}
    validates_presence_of :school_id, :allow_blank => true
    validates :phone_num, format: { with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only" }, :allow_blank => true
    validates :role, inclusion: { in: %w[admin manager volunteer teacher], message: "is not a recognized role in system" }
    validates :is_active, inclusion: { in: [ true, false ] , message: "Must be true or false" }
    validate :class_size_present
    validate :valid_school
    

    validates :email, presence: true, uniqueness: { case_sensitive: false}, format: { with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format" }
    validates_confirmation_of :password, on: :create, message: "does not match"
    validates_presence_of :encrypted_password, on: :create 
    


    #Relationships
    belongs_to :school, optional: true

    has_many :owned_reservations, :class_name => 'Reservation', :foreign_key => 'teacher_id'
   
    has_many :kits, through: :reservations
    has_many :items, through: :kits

    # Callbacks
    before_save :reformat_phone



  
  ROLES = [['admin', :admin],['manager', :manager],['volunteer', :volunteer],['teacher',:teacher]]





    scope :alphabetical, -> { order('last_name, first_name') }
    scope :active, -> { where(is_active: true) }
    scope :inactive, -> { where.not(is_active: true) }
    scope :employees,     -> { where.not('role = ?', "teacher") }
    scope :teachers,     -> { where(role: 'teacher') }
    scope :volunteers,     -> { where(role: 'volunteer') }


  def has_role?(authorized_role)
    return false if role.nil?
    self.role.downcase.to_sym == authorized_role
  end

  def can_checkin
    (self.role.downcase  == "admin" || self.role.downcase  == "manager" || self.role.downcase  == "volunteer") && self.is_active == true
  end

  def can_rent
   (self.role.downcase  == "admin" || self.role.downcase  == "manager" || self.role.downcase  == "teacher") && self.is_active == true
  end

  def name
    "#{last_name}, #{first_name}"
  end

  def has_outstanding_kit
    self.owned_reservations.select{|res| res.returned == false}.size > 0
  end

  def destroy
    errors.add(:id, 'Do not delete users')
    false
  end


 private


  def class_size_present
    if(self.role == "teacher")
        if(self.class_size == nil)
          	errors.add(:class_size, 'Teachers need a class size')
            return false
        end
        if(self.class_size <= 0)
          errors.add(:class_size, 'Teachers need a class size greater than 0')
          return false
        end
    end
    return true
  end

  def valid_school
    if(self.school_id == nil)
      return true
    end
    checkid = self.school_id
		unless (School.where(id: checkid).present?)
			errors.add(:is_active, 'School is not present')
			return false
		end
		checkSchool = School.find(checkid)
		unless checkSchool.is_active == true
			errors.add(:is_active,'Needs to be an active School')
			return false
		end
		return true

  end

  def reformat_phone
    phone = self.phone_num.to_s  # change to string in case input as all numbers
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone_num = phone       # reset self.phone to new string
  end

end
