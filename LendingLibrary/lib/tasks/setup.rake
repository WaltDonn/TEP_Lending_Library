namespace :lendinglibrary do
  desc "setup database and import csv"
  task :setup do
    Rake::Task["db:exists"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:setup"].invoke
    Rake::Task["import_incidents_csv:create_incidents"].invoke
  end
end
