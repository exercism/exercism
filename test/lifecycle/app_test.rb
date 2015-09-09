require_relative '../app_helper'

class LifecycleAppTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def alice
    @alice ||= User.create(username: 'alice', github_id: 1)
  end

  def bob
    @bob ||= User.create(username: 'bob', github_id: 2)
  end

  def test_tracks_nitpicks
    submission = Submission.create(user: bob)

    Notify.stub(:everyone, nil) do
      post "/submissions/#{submission.key}/nitpick", {body: "O HAI"}, login(alice)
    end

    assert_equal 2, LifecycleEvent.count

    LifecycleEvent.all.each do |event|
      if event.key == 'received_feedback'
        assert_equal bob.id, event.user_id
      end
      if event.key == 'nitpicked'
        assert_equal alice.id, event.user_id
      end
    end
  end

  def test_does_not_track_commenting_on_own_submission
    submission = Submission.create(user: alice)

    Notify.stub(:everyone, nil) do
      post "/submissions/#{submission.key}/nitpick", {body: "O HAI"}, login(alice)
    end

    assert_equal 0, LifecycleEvent.count
  end

  def test_tracks_submission_archived
    submission = Submission.create(user: alice, language: 'ruby', slug: 'one')
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'one').update

    post "/exercises/#{submission.reload.user_exercise.key}/archive", {}, login(alice)

    assert_equal 1, LifecycleEvent.count
    event = LifecycleEvent.first
    assert_equal 'completed', event.key
    assert_equal alice.id, event.user_id
  end
end
