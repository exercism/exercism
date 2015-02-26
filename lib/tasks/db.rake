namespace :db do
  require 'bundler'
  Bundler.require
  require_relative '../db/connection'
  DB::Connection.establish

  desc 'Creates the database from DATABASE_URL or config/database.yml for the current RACK_ENV (use db:create:all to create all databases in the config). Without RACK_ENV it defaults to creating the development and test databases.'
  task :create do
    env = ENV['RACK_ENV'] || 'development'
    db_config = DB::Config.new(env)
    ActiveRecord::Base.configurations = YAML.load(db_config.yaml)
    ActiveRecord::Tasks::DatabaseTasks.create_current(env)
  end

  desc "migrate your database"
  task :migrate do
    ActiveRecord::Migrator.migrate('./db/migrate')
  end

  task :rollback do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback('./db/migrate', step)
  end

  namespace :migrate do
    task :down do
      version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
      raise 'VERSION is required - To go down one migration, run db:rollback' unless version
      ActiveRecord::Migrator.run(:down, './db/migrate', version)
    end
  end

  desc "set up your database"
  task :setup do
    `createuser -s exercism`
    `createdb -O exercism exercism_development`
  end

  desc "drop and recreate your database"
  task :reset do
    `dropdb exercism_development`
    `createdb -O exercism exercism_development`
  end

  namespace :generate do
    desc "generate migration"
    task :migration do
      require 'active_support/all'
      name = ENV['name'] || ENV['NAME']
      if name.nil?
        $stderr.puts "Usage: rake db:generate:migration name=the_name_of_your_migration"
        exit 1
      end

      now = Time.now.strftime("%Y%m%d%H%M")
      filename = "./db/migrate/#{now}_#{name.underscore}.rb"
      text = <<-text
class #{name.camelcase} < ActiveRecord::Migration
  def change
  end
end
      text
      File.open(filename, 'w') do |f|
        f.puts text
      end
    end
  end
end
