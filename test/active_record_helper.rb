require 'active_record'
require 'database_cleaner'
require 'minitest/unit'
require_relative '../lib/exercism/manages_database'

ManagesDatabase.establish_connection

DatabaseCleaner.strategy = :transaction


class Minitest::Test
  def setup
    DatabaseCleaner.start
  end
  def teardown
    DatabaseCleaner.clean
  end
end
