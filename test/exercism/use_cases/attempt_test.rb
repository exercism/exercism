require './test/integration_helper'

class NongCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('nong', 'no', 'not')
  end
end

class FempCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('femp', 'fp', 'fpt')
  end
end

class AttemptTest < Minitest::Test

  attr_reader :user, :curriculum
  def setup
    @user = User.create(current: {'nong' => 'one', 'femp' => 'one'})
    @curriculum = Curriculum.new('/tmp')
    @curriculum.add NongCurriculum.new
    @curriculum.add FempCurriculum.new
  end

  def teardown
    Mongoid.reset
  end

  def test_saving_an_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard

    Attempt.new(user, 'CODE', 'one.no', curriculum).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'nong', submission.language
    assert_equal 'one', submission.slug
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_correct_submission
    assert_equal 0, Submission.count # guard

    Attempt.new(user, 'CODE', 'one.fp', curriculum).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'femp', submission.language
    assert_equal 'one', submission.slug
    assert_equal user, submission.user
  end

  def test_a_new_attempt_supersedes_the_previous_one
    Attempt.new(user, 'CODE 1', 'one.fp', curriculum).save
    Attempt.new(user, 'CODE 2', 'one.fp', curriculum).save
    one, two = user.submissions
    assert_equal 'superseded', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_an_attempt_does_not_supersede_other_languages
    Attempt.new(user, 'CODE', 'one.no', curriculum).save
    Attempt.new(user, 'CODE', 'one.fp', curriculum).save
    one, two = user.submissions
    assert_equal 'pending', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_an_attempt_includes_the_code_in_the_submission
    Attempt.new(user, 'CODE 123', 'one.no', curriculum).save
    assert_equal 'CODE 123', user.submissions.first.reload.code
  end

  def test_previous_submission_after_first_attempt
    attempt = Attempt.new(user, 'CODE', 'one.fp', curriculum).save
    assert_equal attempt.previous_submission.class, NullSubmission
  end

  def test_previous_submission_after_first_attempt_in_new_language
    Attempt.new(user, 'CODE 1', 'one.fp', curriculum).save
    attempt = Attempt.new(user, 'CODE 2', 'one.no', curriculum).save
    assert_equal attempt.previous_submission.language, "nong"
  end

  def test_previous_submission_after_superseding
    Attempt.new(user, 'CODE 1', 'one.fp', curriculum).save
    attempt = Attempt.new(user, 'CODE 2', 'one.fp', curriculum).save
    one = user.submissions.first
    assert_equal attempt.previous_submission, one
  end

  def test_previous_submission_with_new_language_sandwich
    Attempt.new(user, 'CODE 1', 'one.fp', curriculum).save
    Attempt.new(user, 'CODE 2', 'one.no', curriculum).save
    attempt = Attempt.new(user, 'CODE 3', 'one.fp', curriculum).save
    assert_equal attempt.previous_submission, user.submissions.first
  end
end

