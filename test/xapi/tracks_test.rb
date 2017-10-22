require_relative 'xapi_helper'

class XapiTracksTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    super
    Approvals.configure_for_xapi
  end

  def teardown
    Approvals.configure_for_io
  end

  def app
    Xapi::App
  end

  def test_all_the_tracks
    get '/tracks'
    tracks = JSON.parse(last_response.body)['tracks'].map { |track| track['slug'] }
    Approvals.verify(tracks, name: 'xapi_get_tracks')
  end

   def test_all_the_todos
     get '/tracks'
     tracks = JSON.parse(last_response.body)['tracks'].find { |track|
       track['slug'] == 'fruit'
     }['todo'].sort
     Approvals.verify(tracks, name: 'xapi_get_fruit_todo')
   end

   def test_a_track
     get '/tracks/fake'
     Approvals.verify(last_response.body, format: :json, name: 'xapi_get_track_fake')
   end

   def test_track_does_not_exist
     get '/tracks/unknown'
     assert_equal last_response.status, 404
     Approvals.verify(last_response.body, format: :json, name: 'xapi_get_invalid_track')
   end
end
