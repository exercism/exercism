require_relative '../api_helper'

class LifecycleApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def alice
    @alice ||= User.create(username: 'alice', github_id: 1)
  end

  def assert_tracked(event, key, user_id)
    assert_equal key, event.key
    assert_equal user_id, event.user_id
  end

  def test_tracks_submit
    Notify.stub(:everyone, nil) do
      X::Exercise.stub(:exists?, true) do
        post '/user/assignments', {key: alice.key, solution: {'one/code.rb' => 'THE CODE'}}.to_json
      end
    end

    assert_equal 2, LifecycleEvent.count
    assert_tracked LifecycleEvent.first, 'fetched', alice.id
    assert_tracked LifecycleEvent.last, 'submitted', alice.id
  end
end
