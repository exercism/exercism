namespace :db do
  namespace :migrate do
    desc "migrate the data from MongoDB to PostgreSQL"
    task :data do
      require './lib/exercism/manages_database'
      require './lib/db/data_migration/manages_mongoid'
      require './lib/db/data_migration'
      DataMigration.execute
    end
  end
end
