require './test/app_helper'
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
    get "/completed/ruby/bob", {}, {'rack.session' => {github_id: alice.github_id}}
    assert_equal 200, last_response.status
  end

end
