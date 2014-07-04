require_relative '../test_helper'
require 'db/config'

class DB::ConfigTest < MiniTest::Test
  def relative_to_root(*paths)
    File.expand_path(File.join(__FILE__, '..', '..', '..', *paths))
  end

  def test_default_file
    file = relative_to_root('config', 'database.yml')
    assert_equal file, DB::Config.new('env').file
  end

  def test_sets_the_database_setting_relative_to_root_if_sqlite
    file = relative_to_root('config', 'database.yml')
    db_connection_string = relative_to_root('db', 'exercism_test.sqlite')

    assert_equal db_connection_string, DB::Config.new('test').options['database']
  end

  def test_dont_change_database_setting_if_anything_else
    assert_equal 'exercism_development', DB::Config.new('development').options['database']
  end

  def test_override_file
    file = relative_to_root('test', 'fixtures', 'database.yml')
    assert_equal file, DB::Config.new('env', file).file
  end

  def test_read_environment_specific_values
    file = relative_to_root('test', 'fixtures', 'database.yml')
    config = DB::Config.new('fake', file)
    options = {
      'adapter' => 'sqlite3',
      'database' => relative_to_root('db/betterful_fake')
    }
    assert_equal options, config.options
  end

  def test_blow_up_for_unknown_environment
    file = relative_to_root('test', 'fixtures', 'database.yml')
    config = DB::Config.new('real', file)

    assert_raises DB::Config::UnconfiguredEnvironment do
      config.options
    end
  end
end
