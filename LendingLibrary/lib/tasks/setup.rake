namespace :lendinglibrary do
  desc "setup database and import csvs"
  # task :setup do
    # ActiveRecord::Base.establish_connection('development')
    # RAILS_ENV = "development"
    # Rake::Task["db:exists"].invoke
    # Rake::Task["db:create"].invoke
    # Rake::Task["db:setup"].invoke
    # Rake::Task["db:migrate"].invoke
    # Rake::Task["import_incidents_csv:create_incidents"].invoke
    # ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'])  #Make sure you don't have side-effects!

    task :setup do
      system("rake db:exists RAILS_ENV=development")
      system("rake db:create RAILS_ENV=development")
      system("rake db:setup RAILS_ENV=development")
      system("rake db:migrate RAILS_ENV=development")
      system("rake import_incidents_csv:create_incidents RAILS_ENV=development")
    end


  desc "import csvs"
  task :import do
    Rake::Task["import_incidents_csv:create_incidents"].invoke
  end

end
