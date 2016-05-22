ENV['RACK_ENV'] = 'test'
require_relative './test_helper'
gem 'activerecord', '~> 4.0'
require 'active_record'
require 'database_cleaner'
require 'db/connection'

I18n.enforce_available_locales = false

DB::Connection.establish

if defined?(ActiveRecord::Migrator) && ActiveRecord::Migrator.needs_migration?
  fail 'Migrations are pending run `rake db:migrate RACK_ENV=test` to resolve the issue.'
end

DatabaseCleaner.strategy = :transaction

module DBCleaner
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
