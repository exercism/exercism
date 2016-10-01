require_relative '../test_helper'
require_relative '../x_helper'
require_relative '../integration_helper'

class UserTracksSummaryTest < Minitest::Test
  include DBCleaner

  def setup
    super
    @user = User.create
    @f = './test/fixtures/xapi_v3_tracks.json'
  end

  def test_user_tracks_summary_completed
    X::Xapi.stub(:get, [200, File.read(@f)]) do
      UserExercise.create(user: @user, language: 'animal', iteration_count: 1)
      actual = UserTracksSummary.call(@user).first
      assert_equal UserTracksSummary::TrackSummary, actual.class
      assert_equal true, actual.completed?
      assert_equal 1, actual.completed
      assert_equal false, actual.reviewed?
    end
  end

  def test_user_tracks_summary_reviewed
    X::Xapi.stub(:get, [200, File.read(@f)]) do
      user2 = User.create
      exercise = UserExercise.create(user: user2, language: 'animal', iteration_count: 1)
      submission = Submission.create(user: user2, language: 'animal', slug: 'dog', version: 1, user_exercise: exercise)
      Comment.create(user: @user, body: 'test', html_body: '<p>test</p>', submission: submission)
      actual = UserTracksSummary.call(@user).first
      assert_equal UserTracksSummary::TrackSummary, actual.class
      assert actual.reviewed?
      assert_equal 1, actual.reviewed
      refute actual.completed?
    end
  end
end
