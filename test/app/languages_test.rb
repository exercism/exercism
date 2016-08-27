require_relative '../app_helper'

class LanguagesRoutesTest < Minitest::Test
  include Rack::Test::Methods

  BASE_URL = "http://#{Rack::Test::DEFAULT_HOST}".freeze

  def app
    ExercismWeb::App
  end

  def test_route_languages
    fixture = './test/fixtures/xapi_v3_tracks.json'
    X::Xapi.stub(:get, [200, File.read(fixture)]) do
      get '/languages'
      assert_equal 200, last_response.status
      assert_match 'Animal', last_response.body
      assert_match 'Fake', last_response.body
      assert_match 'Fancy Stones', last_response.body
      assert_match 'Fruit', last_response.body
      assert_match 'Shoes & Boots', last_response.body
    end
  end

  def test_route_repositories
    fixture = './test/fixtures/xapi_v3_tracks.json'
    X::Xapi.stub(:get, [200, File.read(fixture)]) do
      get '/repositories'
      assert_equal 200, last_response.status
      assert_match 'Exercism Repositories', last_response.body
      assert_match 'Basic Components', last_response.body
      assert_match 'Exercises', last_response.body
      assert_match 'Interesting Tools', last_response.body
      assert_match 'Language tracks you can contribute to', last_response.body
      assert_match 'In Progress', last_response.body
      assert_match 'Planned', last_response.body
    end
  end

  def test_route_languages_invalid_track
    fixture = './test/fixtures/xapi_v3_tracks_error.json'
    X::Xapi.stub(:get, [200, File.read(fixture)]) do
      get '/languages/invalid_track'
      assert_equal 200, last_response.status
      assert_match "It doesn't look like we have <b>invalid_track</b> yet", last_response.body
    end
  end

  def test_route_languages_valid_track
    fixture = './test/fixtures/xapi_v3_track.json'
    X::Xapi.stub(:get, [200, File.read(fixture)]) do
      get '/languages/animal'
      assert_equal 200, last_response.status
      assert_match "About the Animal Track", last_response.body
      assert_match "Available Exercises", last_response.body
      assert_match "Installing Animal", last_response.body
      assert_match "Running the Tests", last_response.body
      assert_match "Learning Animal", last_response.body
      assert_match "Useful Animal Resources", last_response.body
      assert_match "Getting Help", last_response.body
      assert_match "Contributing to Animal on Exercism", last_response.body
    end
  end

  def test_route_contribute
    fixture = './test/fixtures/xapi_v3_todos.json'
    X::Xapi.stub(:get, [200, File.read(fixture)]) do
      get '/languages/testlanguage/contribute'
      assert_equal 200, last_response.status
      assert_match 'Alphametics', last_response.body
      assert_match 'Bank Account', last_response.body
    end
  end

  def test_route_contribute_complete
    fixture = './test/fixtures/xapi_v3_todos_none.json'
    X::Xapi.stub(:get, [200, File.read(fixture)]) do
      get '/languages/complete/contribute'
      assert_equal 200, last_response.status
      assert_match 'All exercises are implemented in Complete', last_response.body
    end
  end

  def test_route_contribute_invalid_language
    X::Xapi.stub(:get, [404, "{\"error\":\"No track 'nonexistant'\"}"]) do
      get '/languages/nonexistant/contribute'
      assert_equal 404, last_response.status
      assert_match 'It doesn\'t look like we have <b>nonexistant</b> yet.', last_response.body
    end
  end

  def test_route_valid_track_with_invalid_topic
    get '/languages/valid_track/invalid_topic'
    assert_equal 404, last_response.status
    assert_match "It doesn't look like we have <b>invalid_topic</b> yet", last_response.body
  end

  def test_route_invalid_track_with_valid_topic
    fixture = './test/fixtures/xapi_v3_tracks_error.json'
    X::Xapi.stub(:get, [404, File.read(fixture)]) do
      get '/languages/invalid_track/about'
      assert_equal 404, last_response.status
      assert_match "It doesn't look like we have <b>invalid_track</b> yet", last_response.body
    end
  end

  def test_route_valid_track_with_valid_topic
    fixture = './test/fixtures/xapi_v3_track.json'
    X::Xapi.stub(:get, [200, File.read(fixture)]) do
      get '/languages/animal/about'
      assert_equal 200, last_response.status
      assert_match "About the Animal Track", last_response.body
      assert_match "Available Exercises", last_response.body
      assert_match "Installing Animal", last_response.body
      assert_match "Running the Tests", last_response.body
      assert_match "Learning Animal", last_response.body
      assert_match "Useful Animal Resources", last_response.body
      assert_match "Getting Help", last_response.body
      assert_match "Contributing to Animal on Exercism", last_response.body
    end
  end
end
