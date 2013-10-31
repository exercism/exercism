require './test/app_helper'
require 'mocha/setup'

class ExercisesTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismApp
  end

  def test_exercise_gallery
    User.any_instance.expects(:completed?).returns(true)
    alice = User.create(username: 'alice', github_id: 1, email: 'alice@example.com')
    get "/completed/ruby/bob", {}, login(alice)
    assert_equal 200, last_response.status
  end

end
