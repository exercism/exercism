ENV['RACK_ENV'] = 'test'
require 'English'
$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)

require 'simplecov' if ENV['COVERAGE']
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'
require 'active_record'
require 'db/connection'
require 'database_cleaner'
require 'yaml'
require_relative '../approvals_hack'

require_relative '../../api/xapi'

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

Trackler.use_fixture_data
