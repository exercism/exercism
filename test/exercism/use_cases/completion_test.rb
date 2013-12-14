require './test/integration_helper'
require './test/fixtures/fake_curricula'

class CompletionTest < Minitest::Test
  include DBCleaner

  attr_reader :submission, :user, :curriculum
  def setup
    super
    @curriculum = Curriculum.new('/tmp')
    @curriculum.add FakeRubyCurriculum.new
    @user = User.create(username: 'bob', current: {'ruby' => 'one'}, github_id: 1)

    attempt = Attempt.new(user, 'CODE', 'one/one.rb', curriculum).save
    @submission = Submission.first
  end

  def test_complete_a_submission
    Completion.new(submission, curriculum).save
    submission.reload
    assert_equal 'done', submission.state
    assert !submission.done_at.nil?

    user.reload
    done = {'ruby' => ['one']}
    assert_equal done, user.completed
    assert_nil user.current['ruby']
  end
end

