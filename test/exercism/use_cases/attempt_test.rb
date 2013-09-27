require './test/integration_helper'

class NongCurriculum
  def slugs
    %w(one two three)
  end

  def locale
    Locale.new('nong', 'no', 'not')
  end
end

class FempCurriculum
  def slugs
    %w(one two three)
  end

  def locale
    Locale.new('femp', 'fp', 'fpt')
  end
end

class AttemptTest < Minitest::Test

  attr_reader :user, :curriculum
  def setup
    super
    data = {
      completed: {'nong' => ['one'], 'femp' => ['one']}
    }
    @user = User.create(data)
    @curriculum = Curriculum.new('/tmp')
    @curriculum.add NongCurriculum.new
    @curriculum.add FempCurriculum.new
  end

  def teardown
    super
    @user = nil
  end

  def test_saving_an_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard

    Attempt.new(user, 'CODE', 'two/two.no', curriculum).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'nong', submission.language
    assert_equal 'two', submission.slug
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_current_exercise
    assert_equal 0, Submission.count # guard

    Attempt.new(user, 'CODE', 'two/two.fp', curriculum).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'femp', submission.language
    assert_equal 'two', submission.slug
    assert submission.pending?
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_completed_exercise
    assert_equal 0, Submission.count # guard

    Attempt.new(user, 'CODE', 'one/one.fp', curriculum).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'femp', submission.language
    assert_equal 'one', submission.slug
    assert submission.tweaked?, 'tweaked'
    assert_equal user, submission.user
  end

  def test_a_new_attempt_supersedes_the_previous_one
    Attempt.new(user, 'CODE 1', 'two/two.fp', curriculum).save
    Attempt.new(user, 'CODE 2', 'two/two.fp', curriculum).save
    one, two = user.submissions
    assert_equal 'superseded', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_a_new_attempt_supersedes_the_previous_hibernating_one
    submission = Submission.create(user: user, language: 'femp', slug: 'two', at: Time.now, state: 'hibernating')
    Attempt.new(user, 'CODE 2', 'two/two.fp', curriculum).save
    one, two = user.reload.submissions
    assert one.superseded?
    assert two.pending?
  end

  def test_a_new_attempt_unmutes_previous_attempt
    tom = User.create(username: 'tom')
    jerry = User.create(username: 'jerry')
    submission = Submission.create(user: user, language: 'femp', slug: 'two', at: Time.now, muted_by: [tom, jerry])
    Attempt.new(user, 'CODE 2', 'two/two.fp', curriculum).save
    assert_equal [], submission.reload.muted_by
  end

  def test_an_attempt_does_not_supersede_other_languages
    Attempt.new(user, 'CODE', 'two/two.no', curriculum).save
    Attempt.new(user, 'CODE', 'two/two.fp', curriculum).save
    one, two = user.submissions
    assert_equal 'pending', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_an_attempt_includes_the_code_in_the_submission
    Attempt.new(user, 'CODE 123', 'two/two.no', curriculum).save
    assert_equal 'CODE 123', user.submissions.first.reload.code
  end

  def test_previous_submission_after_first_attempt
    attempt = Attempt.new(user, 'CODE', 'two/two.fp', curriculum).save
    assert_equal attempt.previous_submission.class, NullSubmission
  end

  def test_previous_submission_after_first_attempt_in_new_language
    Attempt.new(user, 'CODE 1', 'two/two.fp', curriculum).save
    attempt = Attempt.new(user, 'CODE 2', 'two/two.no', curriculum).save
    assert_equal attempt.previous_submission.language, "nong"
  end

  def test_previous_submission_after_superseding
    Attempt.new(user, 'CODE 1', 'two/two.fp', curriculum).save
    attempt = Attempt.new(user, 'CODE 2', 'two/two.fp', curriculum).save
    one = user.submissions.first
    assert_equal attempt.previous_submission, one
  end

  def test_previous_submission_with_new_language_sandwich
    Attempt.new(user, 'CODE 1', 'two/two.fp', curriculum).save
    Attempt.new(user, 'CODE 2', 'two/two.no', curriculum).save
    attempt = Attempt.new(user, 'CODE 3', 'two/two.fp', curriculum).save
    assert_equal attempt.previous_submission, user.submissions.first
  end

  def test_newlines_are_removed_at_the_end_of_the_file
    Attempt.new(user, "\nCODE1\n\nCODE2\n\n\n", 'two/two.fp', curriculum).save
    assert_equal "\nCODE1\n\nCODE2", user.submissions.first.code
  end

  def test_rejects_duplicates
    first_attempt = Attempt.new(user, "\nCODE1\n\nCODE2\n\n\n", 'two/two.fp', curriculum).save
    second_attempt =  Attempt.new(user, "\nCODE1\n\nCODE2\n\n\n", 'two/two.fp', curriculum)

    assert_equal true, second_attempt.duplicate?
  end

  def test_no_reject_without_previous
    attempt = Attempt.new(user, "\nCODE1\n\nCODE2\n\n\n", 'two/two.fp', curriculum)
    assert_equal false, attempt.duplicate?
  end

  def test_attempt_sets_exercise_as_current
    attempt = Attempt.new(user, "\nCODE1\n\nCODE2\n\n\n", 'two/two.fp', curriculum).save
    assert user.working_on?(Exercise.new('femp', 'two'))
  end

  def test_attempt_doesnt_set_completed_exercise_as_current
    attempt = Attempt.new(user, "\nCODE1\n\nCODE2\n\n\n", 'one/one.fp', curriculum).save
    refute user.working_on?(Exercise.new('femp', 'one'))
  end
end

