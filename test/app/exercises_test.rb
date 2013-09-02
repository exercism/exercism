require './test/api_helper'
require 'mocha/setup'

class ExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def setup
    @alice = User.create(username: 'alice', github_id: 1, email: 'alice@example.com')
  end

  def teardown
    Mongoid.reset
  end

  def logged_in
    { github_id: @alice.github_id }
  end

  def test_exercise_gallery
    User.any_instance.expects(:completed?).returns(true)
    get "/completed/ruby/bob", {}, 'rack.session' => logged_in
    assert_equal 200, last_response.status
  end

end
