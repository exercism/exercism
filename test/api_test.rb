require './test/api_helper'

class ExercismAPI < Sinatra::Base
  get '/' do
    require_user
    "OK"
  end
end

class ApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismAPI
  end

  def login(user)
    set_cookie("_exercism_login=#{user.github_id}")
  end

  def alice
    @alice ||= User.create(username: 'alice', github_id: 1)
  end

  def test_require_user_tells_guest_401
    get '/'
    assert_equal 401, last_response.status
    assert_equal "You must be logged in to access this feature. Please double-check your API key.", JSON.parse(last_response.body)['error']
  end

  def test_require_user_accepts_cookie
    login(alice)
    get '/'
    assert_equal 200, last_response.status
    assert_equal "OK", last_response.body
  end

  def test_require_user_accepts_api_key
    get '/', key: alice.key
    assert_equal 200, last_response.status
    assert_equal "OK", last_response.body
  end

  def test_does_not_blow_up_if_no_such_user_key
    get '/', key: "123"
    assert_equal 401, last_response.status
    assert_equal "You must be logged in to access this feature. Please double-check your API key.", JSON.parse(last_response.body)['error']
  end

  def test_does_not_blow_up_if_no_such_user_session
    user = Object.new
    def user.github_id
      1
    end

    get '/'
    assert_equal 401, last_response.status
    assert_equal "You must be logged in to access this feature. Please double-check your API key.", JSON.parse(last_response.body)['error']
  end
end

