$:.unshift File.expand_path("../../lib", __FILE__)

ENV['RACK_ENV'] = 'test'
require 'simplecov' if ENV['COVERAGE']

require 'active_record'
require 'db/connection'
DB::Connection.establish
if defined?(ActiveRecord::Migrator) && ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending run `rake db:migrate RACK_ENV=test` to resolve the issue.'
end

require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
