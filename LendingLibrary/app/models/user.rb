class User < ApplicationRecord
    has_secure_password
    validates_presence_of :first_name
    validates_presence_of :last_name
    validates_presence_of :role
    validates_presence_of :email
    validates :email, uniqueness: true
    validates :first_name, format: {with: /\A[A-Za-z\-]+\z/, message: "Should be a valid name"}
    validates :email, format: {with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/, message: "Should be a valid email"}
    validates_presence_of :school_id, :allow_blank => true
    validates :phone_num, format: { with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only" }, :allow_blank => true
    validates :role, inclusion: { in: %w[admin manager volunteer teacher], message: "is not a recognized role in system" }

    validate :valid_school
    

    #Relationships
    belongs_to :school, optional: true
    has_many :reservations
    has_many :kits, through: :reservations
    has_many :items, through: :kits

    # Callbacks
    before_destroy :destroyable
    before_save :reformat_phone



  # For use in authorizing with CanCan
  ROLES = [['Administrator', :admin],['Manager', :manager],['Volunteer', :volunteer],['Teacher',:teacher]]

    
    
    
    
    scope :alphabetical, -> { order('last_name, first_name') }
    scope :active, -> { where(is_active: true) }
    scope :inactive, -> { where.not(is_active: true) }
    scope :employees,     -> { where.not('role = ? OR role = ?', "teacher", "volunteer") }
    scope :teachers,     -> { where(role: 'teacher') }
    scope :volunteers,     -> { where(role: 'volunteer') }


  def name
    "#{last_name}, #{first_name}"
  end

  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end

  def has_outstanding_kit
    #Map to boolean returned values
    #If one of them is false, then a kit has not been returned
    #Check corner case of only 1 kit
    self.reservations.map{|res| res.returned}.inject{|res1, res2| rest1 AND res2}
  end

  private
  def destroyable
    false
  end
  
  def valid_school
    if(self.school_id == nil)
      return true
    end
    checkid = self.school_id
		unless (School.where(id: checkid).present?) 
			errors.add(:active, 'School is not present')
			return false
		end
		checkSchool = School.find(checkid)
		unless checkSchool.is_active == true
			errors.add(:active,'Needs to be an active School')
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
