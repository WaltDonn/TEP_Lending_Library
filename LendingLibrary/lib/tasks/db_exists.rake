namespace :db do
  desc "Checks to see if the database exists"
  task :exists do
    begin
      Rake::Task['environment'].invoke
      ActiveRecord::Base.connection
    rescue
      # Do nothing if the database doesn't exist
      # exit 1
    else
      # Drop the database if it already exists
      Rake::Task['db:drop'].invoke
      # exit 0
    end
  end
end
