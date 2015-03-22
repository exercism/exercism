require_relative '../test_helper'
require 'db/config'

class DB::ConfigTest < Minitest::Test
  def relative_to_root(*paths)
    File.expand_path(File.join(__FILE__, '..', '..', '..', *paths))
  end

  def test_default_file
    file = relative_to_root('config', 'database.yml')
    assert_equal file, DB::Config.new('env').file
  end

  def test_database_name_comes_from_environment_by_default
    assert_equal 'exercism_development', DB::Config.new('development').options['database']
  end

  def test_defaults_to_the_current_environment
    assert_equal 'test', DB::Config.new.environment
  end

  def test_uses_environment_from_RACK_ENV
    original_rack_env = ENV.delete('RACK_ENV')
    ENV['RACK_ENV'] = 'custom'
    assert_equal 'custom', DB::Config.new.environment
  ensure
    ENV['RACK_ENV'] = original_rack_env if original_rack_env
  end

  def test_defaults_to_development_if_RACK_ENV_unset
    original_rack_env = ENV.delete('RACK_ENV')
    assert_equal 'development', DB::Config.new.environment
  ensure
    ENV['RACK_ENV'] = original_rack_env if original_rack_env
  end

  def test_override_file
    file = relative_to_root('test', 'fixtures', 'database.yml')
    assert_equal file, DB::Config.new('env', file).file
  end

  def test_read_environment_specific_values
    file = relative_to_root('test', 'fixtures', 'database.yml')
    config = DB::Config.new('fake', file)
    options = {
      'adapter' => 'postgresql',
      'database' => 'betterful_fake'
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
