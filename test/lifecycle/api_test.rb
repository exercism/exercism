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
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'one/code.rb'}.to_json
      end
    end

    assert_equal 2, LifecycleEvent.count
    assert_tracked LifecycleEvent.first, 'fetched', alice.id
    assert_tracked LifecycleEvent.last, 'submitted', alice.id
  end

  def test_tracks_fetch_when_language
    Xapi.stub(:get, 200, "{}") do
      get '/exercises/ruby', key: alice.key
    end

    assert_equal 1, LifecycleEvent.count
    assert_tracked LifecycleEvent.first, 'fetched', alice.id
  end

  def test_tracks_fetch_when_exercise
    Xapi.stub(:get, 200, "{}") do
      get '/exercises/ruby/bob', key: alice.key
    end

    assert_equal 1, LifecycleEvent.count
    assert_tracked LifecycleEvent.first, 'fetched', alice.id
  end
end
