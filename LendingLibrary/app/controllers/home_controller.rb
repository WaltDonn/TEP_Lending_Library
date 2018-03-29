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
			@user.school_id = row['school_id']
			@user.is_active = true
			@user.role = params['create_users']['role']
			#if this isnt working, make sure to check you have figaro setup
			if @user.save
				AccountMailer.welcome(@user, generated_password).deliver
			else
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
  
  
end
