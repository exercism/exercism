$LOAD_PATH.unshift File.expand_path("./../../lib", __FILE__)
require 'bundler'
Bundler.require
require 'exercism'

ENV['RACK_ENV'] ||= 'development'

require 'active_record'
require 'db/connection'
DB::Connection.establish
if defined?(ActiveRecord::Migrator) && ActiveRecord::Migrator.needs_migration?
  fail 'Migrations are pending run `rake db:migrate` to resolve the issue.'
end

def user(username)
  User.find_by_username(username)
end

def submission(key)
  Submission.find_by_key(key)
end

def exercise(key)
  UserExercise.find_by_key(key)
end
