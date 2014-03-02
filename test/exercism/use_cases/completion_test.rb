require './test/integration_helper'

class CompletionTest < MiniTest::Unit::TestCase
  include DBCleaner

  attr_reader :submission, :user
  def setup
    super
    @user = User.create(username: 'bob', github_id: 1)

    attempt = Attempt.new(user, 'CODE', 'one/one.rb').save
    @submission = Submission.first
  end

  def test_complete_a_submission
    Completion.new(submission).save
    submission.reload
    assert_equal 'done', submission.state
    refute submission.done_at.nil?
  end
end

