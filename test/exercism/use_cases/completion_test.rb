require './test/integration_helper'
require './test/fixtures/fake_curricula'

class CompletionTest < Minitest::Test

  attr_reader :submission, :user, :curriculum
  def setup
    super
    @curriculum = Curriculum.new('/tmp')
    @curriculum.add FakeCurriculum.new
    @user = User.create(username: 'bob', current: {'fake' => 'one'}, github_id: 1)

    attempt = Attempt.new(user, 'CODE', 'one/one.ext', curriculum).save
    @submission = Submission.first
  end

  def test_complete_a_submission
    Completion.new(submission, curriculum).save
    submission.reload
    assert_equal 'done', submission.state
    assert !submission.done_at.nil?

    user.reload
    done = {'fake' => ['one']}
    assert_equal done, user.completed
    assert_nil user.current['fake']
  end

  def test_unlocked_exercise
    completion = Completion.new(submission, curriculum).save
    assert_equal Exercise.new('fake', 'two'), completion.unlocked
  end
end

