require 'csv'
require 'active_record'
require 'activerecord-import'

namespace :import_incidents_csv do

  desc "Import all csv files to database"
  task :create_incidents => :environment do
    Rake::Task["import_incidents_csv:create_schools"].invoke
    Rake::Task["import_incidents_csv:create_users"].invoke
    Rake::Task["import_incidents_csv:create_item_categories"].invoke
    Rake::Task["import_incidents_csv:create_component_categories"].invoke
    Rake::Task["import_incidents_csv:create_kits"].invoke
    Rake::Task["import_incidents_csv:create_items"].invoke
    Rake::Task["import_incidents_csv:create_components"].invoke
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
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        User.create!(row.to_h)
      end
    end
  end

  desc "Import reservations"
  task :create_reservations => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'reservations.csv')]
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        res = row.to_h
        res[:start_date] = DateTime.strptime(row[1], "%m/%d/%Y")
        res[:end_date] = DateTime.strptime(row[1], "%m/%d/%Y")
        res[:pick_up_date] = DateTime.strptime(row[1], "%m/%d/%Y")
        res[:return_date] = DateTime.strptime(row[1], "%m/%d/%Y")
        Reservation.create!(res)
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

  desc "Import component categories"
  task :create_component_categories => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', 'component_categories.csv')]
    csvs.each do |csv|
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
        ComponentCategory.create!(row.to_h)
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
