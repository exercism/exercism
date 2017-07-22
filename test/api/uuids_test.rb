require_relative '../api_helper'

class UUIDsApiTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    Trackler.use_fixture_data
  end

  def app
    ExercismAPI::App
  end

  def test_unique_uuid_is_accepted
    # unknown uuid
    uuid = "8f8a5e1f-5e0c-4738-b15b-8d11e1a07b80"
    post '/uuids', { "track_id" =>"fake", "uuids" => [uuid]}.to_json
    assert_equal 204, last_response.status
  end

  def test_uuid_is_acceptable_if_already_defined_in_track
    # defined in 'fake' fixture data
    uuid = "6bef4a04-2200-4478-a22e-1f3117a2f8f1"
    post '/uuids', { "track_id" =>"fake", "uuids" => [uuid]}.to_json
    assert_equal 204, last_response.status
  end

  def test_cannot_have_same_uuid_in_multiple_tracks
    # already used in 'fake' track
    uuid = "6bef4a04-2200-4478-a22e-1f3117a2f8f1"
    post '/uuids', { "track_id" =>"fruit", "uuids" => [uuid]}.to_json
    assert_equal 409, last_response.status
  end
end
