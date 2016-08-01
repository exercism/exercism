require_relative '../app_helper'

class LanguagesRoutesTest < Minitest::Test
  include Rack::Test::Methods

  BASE_URL = "http://#{Rack::Test::DEFAULT_HOST}".freeze

  def app
    ExercismWeb::App
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

end
