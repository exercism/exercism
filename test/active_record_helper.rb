require 'active_record'
require 'database_cleaner'
require 'db/connection'

DB::Connection.establish

DatabaseCleaner.strategy = :transaction

class Minitest::Test
  def setup
    DatabaseCleaner.start
  end
  def teardown
    DatabaseCleaner.clean
  end
end
