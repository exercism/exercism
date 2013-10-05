namespace :db do
  namespace :migrate do
    desc "migrate the data from MongoDB to PostgreSQL"
    task :data do
      require 'pry'
      require './lib/db/connection'
      require './lib/db/data_migration/manages_mongoid'
      require './lib/db/data_migration'
      DB::Connection.establish
      DataMigration.execute
    end
  end
end
