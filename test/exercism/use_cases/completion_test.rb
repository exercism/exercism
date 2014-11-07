require_relative '../../integration_helper'

class CompletionTest < Minitest::Test
  include DBCleaner

  attr_reader :submission, :user, :old_submission
  def setup
    super
    @user = User.create(username: 'bob', github_id: 1)

    Attempt.new(user, 'CODE', 'one/one.rb').save
    Attempt.new(user, 'CODE', 'one/one.rb').save

    @old_submission = Submission.first
    @submission = Submission.last
  end

  def test_complete_a_submission
    Completion.new(submission).save
    submission.reload
    old_submission.reload

    assert_equal 'superseded', old_submission.state
    assert_equal 'done', submission.state
    refute submission.done_at.nil?
  end
end

