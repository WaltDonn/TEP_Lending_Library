require 'csv'
require 'active_record'
require 'activerecord-import'

namespace :import_incidents_csv do
  desc "Import csv files to database"
  task :create_incidents => :environment do
    csvs = Dir[File.join(Rails.root, 'app', 'csvs', '*.csv')]
    csvs.each do |csv|
      # csv_text = File.read(File.join(Rails.root,'app','csvs', csv))
      # csv = CSV.parse(csv_text, :headers => true, :col_sep => ';')
      CSV.foreach(csv, :headers => true, :col_sep => ',') do |row|
      # csv.each do |row|
        School.create!(row.to_hash)
      # end
      end
    end
  end
end
