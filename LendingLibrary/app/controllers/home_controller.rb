require 'csv' 
class HomeController < ApplicationController
  layout 'home'

  def home
  end

  def about
  end

  def contact
  end

  def upload_users
  end

  def create_users
  	# byebug
  	csv_text = File.read(params[:users_csv])
	csv = CSV.parse(csv_text, :headers => true)
	csv.each do |row|
		console.log(row)
  		# User.create!(row.to_hash)
	end
	redirect_to users_url
  end

  def privacy
  end
end
