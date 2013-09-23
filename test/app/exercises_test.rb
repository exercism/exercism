require './test/api_helper'
require 'mocha/setup'

class ExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def teardown
    Mongoid.reset
    clear_cookies
  end

  def test_exercise_gallery
    User.any_instance.expects(:completed?).returns(true)
    alice = User.create(username: 'alice', github_id: 1, email: 'alice@example.com')
    set_cookie("_exercism_login=#{alice.github_id}")
    get "/completed/ruby/bob"
    assert_equal 200, last_response.status
  end

end
