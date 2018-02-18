class User < ApplicationRecord
    has_secure_password
    validates_prescence_of :first_name
    validates_prescence_of :last_name
    validates :phone_num, format: { with: /\d{3}-\d{3}-\d{4}/, message: "bad format" }, :allow_blank => true
    validates :role, inclusion: { in: %w[admin manager volunteer teacher], message: "is not a recognized role in system" }
    
    # Callbacks
    before_destroy false
    before_save :reformat_phone
    
    
    
  # For use in authorizing with CanCan
  ROLES = [['Administrator', :admin],['Manager', :manager],['Volunteer', :volunteer],['Teacher',:teacher]]

    
    
    
    
    scope :alphabetical, -> { order('name') }
    scope :active, -> { where(is_active: true) }
    scope :inactive, -> { where.not(is_active: true) }
    scope :employees,     -> { where.not('role = teacher OR role = volunteer') }
    scope :teachers,     -> { where(role: 'teacher') }
    scope :volunteers,     -> { where(role: 'volunteer') }
    
    
  def name
    "#{last_name}, #{first_name}"
  end
  
  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end
    
  private
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end
    
end
