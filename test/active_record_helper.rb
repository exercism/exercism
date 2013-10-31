ENV['RACK_ENV'] = 'test'
require './test/test_helper'
require 'active_record'
require 'database_cleaner'
require 'db/connection'

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
