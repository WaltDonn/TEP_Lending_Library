namespace :lendinglibrary do
  desc "setup database and import csvs"
  task :setup do
    Rake::Task["db:exists"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:setup"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task['db:test:prepare'].invoke
    Rake::Task["import_incidents_csv:create_incidents"].invoke
  end

  desc "import csvs"
  task :import do
    Rake::Task["import_incidents_csv:create_incidents"].invoke
  end

end
