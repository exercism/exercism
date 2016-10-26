require_relative '../api_helper'

class TracksApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def setup
    super
    @alice = User.create!(username: 'alice', github_id: 1)
  end

  def test_language_status_returns_404_when_language_does_not_exist
    get '/tracks/invalid-language/status', key: @alice.key
    assert_equal 404, last_response.status
  end
end
