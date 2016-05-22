require_relative '../app_helper'

class AppExercisesTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  attr_reader :bob, :alice

  def setup
    super
  end

  def test_track_mentor_invite
    @bob = User.create(username: 'bob', github_id: 2, track_mentor: ['ruby'], email: "bob@example.com")
    @alice = User.create(username: 'alice', github_id: 1, email: "alice@example.com")

    post "/account/track-mentor/invite", { user_to_invite: "alice", track: "ruby" }, login(bob)
    assert_equal 302, last_response.status
    assert true, alice.track_mentor.include?("ruby")
  end
end
