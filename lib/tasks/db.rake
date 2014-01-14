namespace :db do
  desc "migrate your database"
  task :migrate do
    require 'bundler'
    Bundler.require
    require_relative 'lib/db/connection'
    DB::Connection.establish
    ActiveRecord::Migrator.migrate('./db/migrate')
  end
end
