require_relative '../../app_helper'

class ContributeRoutesTest < Minitest::Test
  include Rack::Test::Methods

  BASE_URL = "http://#{Rack::Test::DEFAULT_HOST}".freeze

  def app
    ExercismWeb::App
  end

  def test_route_index
    get '/contribute'
    assert_equal 200, last_response.status
    assert_match 'Contribute to Exercism', last_response.body
  end

  def test_route_canonical_data
    get '/contribute/canonical-data'
    assert_equal 200, last_response.status
    assert_match 'Canonical Data', last_response.body
  end

  # Trackler fixture data dependency
  def test_route_canonical_data_with_slug
    get '/contribute/canonical-data/hello-world'
    assert_equal 200, last_response.status
    assert_match 'Hello World', last_response.body
    refute_match 'We have a total of', last_response.body
  end

  # Trackler fixture data dependency
  def test_route_canonical_data_with_invalid_slug
    get '/contribute/canonical-data/invalid'
    assert_equal 200, last_response.status
    assert_match 'Canonical Data', last_response.body
    assert_match 'We have a total of', last_response.body
  end

  # Trackler fixture data dependency
  def test_route_canonical_data_slug_with_canonical_data
    get '/contribute/canonical-data/fish'
    assert_equal 200, last_response.status
    assert_match 'Canonical Data', last_response.body
    assert_match 'This problem already has a', last_response.body
  end
end

