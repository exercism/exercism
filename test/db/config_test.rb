require './test/test_helper'
require 'db/config'

class DB::ConfigTest < MiniTest::Unit::TestCase
  def test_default_file
    file = File.expand_path(File.join(__FILE__, '..', '..', '..', 'config', 'database.yml'))
    assert_equal file, DB::Config.new('env').file
  end

  def test_override_file
    file = './test/fixtures/database.yml'
    assert_equal file, DB::Config.new('env', file).file
  end

  def test_read_environment_specific_values
    config = DB::Config.new('fake', './test/fixtures/database.yml')
    options = {
      'adapter' => 'sqlite3',
      'database' => 'db/betterful_fake'
    }
    assert_equal options, config.options
  end

  def test_blow_up_for_unknown_environment
    config = DB::Config.new('real', './test/fixtures/database.yml')
    assert_raises DB::Config::UnconfiguredEnvironment do
      config.options
    end
  end
end
