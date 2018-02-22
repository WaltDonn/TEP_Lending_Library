namespace :db do
  desc "Checks to see if the database exists"
  task :exists do
    begin
      Rake::Task['environment'].invoke
      ActiveRecord::Base.connection
    rescue
      # exit 1
    else
      Rake::Task['db:drop'].invoke
      # exit 0
    end
  end
end
