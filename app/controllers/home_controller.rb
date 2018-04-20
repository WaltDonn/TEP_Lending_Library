require 'csv'
require 'tempfile'


class HomeController < ApplicationController
  layout :resolve_layout
  before_action :authenticate_user!, except: [:home]
  

  def home
  end

  def upload_users
  	authorize! :upload_users, :Home
  end


  def create_users
  	authorize! :create_users, :Home

  	failed_emails = Array.new
  	file = params['create_users']['users_csv'].tempfile
	csv = CSV.read(file, :headers => true)
	csv.each do |row|
		generated_password = Devise.friendly_token.first(8)

		@user = User.new
		@user.email = row['email']
		@user.first_name = row['first_name']
		@user.last_name = row['last_name']
		@user.password = generated_password
		@user.password_confirmation = generated_password
		@user.phone_num = row['phone_num']
		@user.phone_ext = row['phone_ext']
		@user.class_size = row['class_size']

      	# Get school id by school name
    
	    unless row['school'].nil? || School.by_name(row['school']).first.nil?
	        @school = School.by_name(row['school']).first
	  		@user.school_id = @school.id
	    end

		@user.is_active = true
		@user.role = params['create_users']['role']
		unless @user.save
			unless @user.errors.messages[:email] == ["has already been taken"]
				failed_emails.push(row['email'])
			end
		end
	end

	if failed_emails.size > 0
		data = "All users added except for users with the following emails: "+failed_emails.join(", ")
		send_data( data, :filename => "failed_accounts.txt" )
	else
		redirect_to users_url
	end

  end

  def upload_schools
  	authorize! :upload_schools, :Home
  end


  def create_schools
  	authorize! :create_schools, :Home

  	failed_schools = Array.new
  	file = params['create_schools']['schools_csv'].tempfile
	csv = CSV.read(file, :headers => true)
	csv.each do |row|
		@school = School.new
		@school.name = row['name']
		@school.street_1 = row['street_1']
		@school.street_2 = row['street_2']
		@school.city = row['city']
		@school.state = row['state']
		@school.zip = row['zip']
		@school.is_active = true
		unless @school.save
			unless @school.errors.messages[:name] == ["already exists for this school at this location"]
				failed_schools.push(row['name'])
			end
		end
	end

	if failed_schools.size > 0
		data = "All schools added except for schools with the following names: "+failed_schools.join(", ")
		send_data( data, :filename => "failed_schools.txt" )
	else
		redirect_to schools_url
	end
  end

  def reports
  	authorize! :reports, :Home
  end

  def gen_reports
  	authorize! :gen_reports, :Home

  	@choice_array = params["gen_reports"]["report_choices"]

  	@items = Item.all

  	@users = User.all

  	@schools = School.all


#---------------------------------------------------------------------------

	# alright, below works except for getting past authentication

 	pdf = PDFKit.new('http://localhost:3000/reports', :page_size => 'A3').to_pdf
 	send_data(pdf, :filename => "reports.pdf", :type => "application/pdf")

	
  end

  def download_reports

  end
	
	def resolve_layout
		case action_name
		when "reports", "gen_reports", "upload_users", "create_users", "upload_schools", "create_schools"
			"home_no_bg"
		else
			"home"
		end
	end

end
