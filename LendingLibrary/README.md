# README

### To populate the sqlite3 database with csv files

#### csv files path
`/app/csvs/<table name>.csv`

#### commands to run rails/rake tasks
`bundle install`

setup drops existing database, import does not
`rails lendinglibrary:setup`
`rails lendinglibrary:import`

to check if the tables are correctly populated
`rails c'
`> School.limit(5).order('id desc')`
