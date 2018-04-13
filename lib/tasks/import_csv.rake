require 'csv'
require 'active_record'
require 'activerecord-import'

namespace :import_incidents_csv do

  desc "Import all csv files to database"
  task :create_incidents => :environment do
    Rake::Task["import_incidents_csv:create_schools"].invoke
    Rake::Task["import_incidents_csv:create_users"].invoke
    Rake::Task["import_incidents_csv:create_item_categories"].invoke
    Rake::Task["import_incidents_csv:create_items"].invoke
    Rake::Task["import_incidents_csv:create_components"].invoke
    Rake::Task["import_incidents_csv:create_kits"].invoke
    Rake::Task["import_incidents_csv:create_reservations"].invoke
  end




  desc "Import schools"
  task :create_schools=> :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'schools.csv')]
    schools_hash = School.pluck(:name, :id).to_h
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        school_id = schools_hash[row[:name]]
        if not school_id
          School.create!(row.to_h)
        end
      end
    end
  end

  desc "Import users"
  task :create_users => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'users.csv')]
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',', :force_quotes => true) do |row|

        @user = User.new
        @user.id = row['id']
        @user.email = row['email']
        @user.first_name = row['first_name']
        @user.last_name = row['last_name']
        @user.password = row['password']
        @user.password_confirmation = row['password_confirmation']
        @user.phone_num = row['phone_num']
        @user.class_size = row['class_size']
        unless School.by_name(row['school']).first.nil?
          @user.school_id = School.by_name(row['school']).first.id
        end
        @user.is_active = true
        @user.role = row['role']
        @user.save!

      end
    end
  end

  desc "Import reservations"
  task :create_reservations => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'reservations.csv')]
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        res = Reservation.new(row.to_h)
        res[:start_date] = DateTime.strptime(row[1], "%Y-%m-%d")
        res[:end_date] = DateTime.strptime(row[2], "%Y-%m-%d")
        res[:pick_up_date] = DateTime.strptime(row[3], "%Y-%m-%d")
        res[:return_date] = DateTime.strptime(row[4], "%Y-%m-%d")
        res.save(:validate => false)
      end
    end
  end

  desc "Import items"
  task :create_items => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'items.csv')]
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        Item.create!(row.to_h)
      end
    end
  end

  desc "Import item categories"
  task :create_item_categories => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'item_categories.csv')]
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        ItemCategory.create!(row.to_h)
      end
    end
  end

  desc "Import components"
  task :create_components => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'components.csv')]
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        Component.create!(row.to_h)
      end
    end
  end

  desc "Import kits"
  task :create_kits => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'kits.csv')]
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        Kit.create!(row.to_h)
      end
    end
  end

end
