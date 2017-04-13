require_relative '../app_helper'
require 'mocha/setup'

class StatsTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def alice_attributes
    {
      username: 'alice',
      github_id: 1,
      email: "alice@example.com",
      created_at: 1.year.ago,
    }
  end

  def opted_out_attributes
    {
      motivation_experiment_opt_out: true,
      username: 'opted_out',
      github_id: 2,
      email: "opted_out@example.com",
      created_at: 1.year.ago,
    }
  end

  attr_reader :alice, :opted_out
  def setup
    super
    @alice = User.create!(alice_attributes)
    @opted_out = User.create!(opted_out_attributes)
    $flipper[:participation_stats].enable
  end

  def assert_response_status(expected_status)
    assert_equal expected_status, last_response.status
  end

  def test_guests_can_load_stats_page
    get '/stats'
    assert_response_status(200)
  end

  def test_users_can_load_stats_page
    get '/stats', {}, login(alice)
    assert_response_status(200)
  end

  def test_opted_out_users_can_load_stats_page
    get '/stats', {}, login(opted_out)
    assert_response_status(200)
  end
end
