require 'csv'
require 'tempfile'

class HomeController < ApplicationController
  layout 'home'
  before_action :authenticate_user!, only: [:upload_users, :create_users]

  def home
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def reports
  end

  def upload_users
  	authorize! :upload_users, nil
  end


  def create_users
  	authorize! :create_users, nil

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
			@user.class_size = row['class_size']

      # Get school id by school name
      @school = School.by_name(row['school']).first
      unless @school.nil?
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
  	authorize! :upload_schools, nil
  end


  def create_schools
  	authorize! :create_schools, nil

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
  	authorize! :reports, nil
  end

  def gen_reports
  	authorize! :gen_reports, nil

  	@one = params["gen_reports"]["input_1"]
  	@two = params["gen_reports"]["input_2"]
  	@choice_array = params["gen_reports"]["report_choices"]

  	@items = Item.all


#---------------------------------------------------------------------------
#currently not working for turning the page into a pdf
	# kit = PDFKit.new(<<-HTML)
	#   <p>Goodbye Envato!</p>
	# HTML
 #  	#kit = PDFKit.new(File.new('app/views/home/gen_reports.html.erb'))
	# #probs not where i should be putting it, temp for now, should also make them name the pdf or it be generated
	# kit.to_file('app/views/reports/hello2.pdf')
  end

end
