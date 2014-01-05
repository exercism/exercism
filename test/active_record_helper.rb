ENV['RACK_ENV'] = 'test'
require './test/test_helper'
gem 'activerecord', '~> 4.0'
require 'active_record'
require 'database_cleaner'
require 'db/connection'

I18n.enforce_available_locales = false

DB::Connection.establish

DatabaseCleaner.strategy = :transaction

module DBCleaner
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
