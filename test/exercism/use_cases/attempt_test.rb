require './test/integration_helper'

class AttemptTest < MiniTest::Unit::TestCase
  include DBCleaner

  attr_reader :user
  def setup
    super
    @user = User.create
  end

  def test_validity
    assert Attempt.new(user, 'CODE', 'two/two.py').valid?
    refute Attempt.new(user, 'CODE', 'two.py').valid?
  end

  def test_saving_an_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard

    Attempt.new(user, 'CODE', 'two/two.py').save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.language
    assert_equal 'two', submission.slug
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_current_exercise
    assert_equal 0, Submission.count # guard

    Attempt.new(user, 'CODE', 'two/two.rb').save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'ruby', submission.language
    assert_equal 'two', submission.slug
    assert submission.pending?
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_completed_exercise
    assert_equal 0, Submission.count # guard

    Attempt.new(user, 'CODE', 'one/one.rb').save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'ruby', submission.language
    assert_equal 'one', submission.slug
    assert submission.pending?, "Expected submission to be pending but was #{submission.state}"
    assert_equal user, submission.user
  end

  def test_a_new_attempt_supersedes_the_previous_one
    Attempt.new(user, 'CODE 1', 'two/two.rb').save
    Attempt.new(user, 'CODE 2', 'two/two.rb').save
    one, two = user.submissions
    assert_equal 'superseded', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_a_new_attempt_supersedes_the_previous_hibernating_one
    submission = Submission.create(user: user, language: 'ruby', slug: 'two', created_at: Time.now, state: 'hibernating')
    Attempt.new(user, 'CODE 2', 'two/two.rb').save
    one, two = user.reload.submissions
    assert one.superseded?
    assert two.pending?
  end

  def test_a_new_attempt_unmutes_previous_attempt
    tom = User.create(username: 'tom')
    jerry = User.create(username: 'jerry')
    submission = Submission.create(user: user, language: 'ruby', slug: 'two', created_at: Time.now)
    submission.mute! tom
    submission.mute! jerry
    Attempt.new(user, 'CODE 2', 'two/two.rb').save
    assert_equal [], submission.reload.muted_by
  end

  def test_an_attempt_does_not_supersede_other_languages
    Attempt.new(user, 'CODE', 'two/two.py').save
    Attempt.new(user, 'CODE', 'two/two.rb').save
    one, two = user.submissions
    assert_equal 'pending', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_an_attempt_includes_the_code_in_the_submission
    Attempt.new(user, 'CODE 123', 'two/two.py').save
    assert_equal 'CODE 123', user.submissions.first.reload.code
  end

  def test_previous_submission_after_first_attempt
    attempt = Attempt.new(user, 'CODE', 'two/two.rb').save
    assert_equal attempt.previous_submission.class, NullSubmission
  end

  def test_previous_submission_after_first_attempt_in_new_language
    Attempt.new(user, 'CODE 1', 'two/two.rb').save
    attempt = Attempt.new(user, 'CODE 2', 'two/two.py').save
    assert_equal attempt.previous_submission.language, "python"
  end

  def test_previous_submission_after_superseding
    Attempt.new(user, 'CODE 1', 'two/two.rb').save
    attempt = Attempt.new(user, 'CODE 2', 'two/two.rb').save
    one = user.submissions.first
    assert_equal attempt.previous_submission, one
  end

  def test_previous_submission_with_new_language_sandwich
    Attempt.new(user, 'CODE 1', 'two/two.rb').save
    Attempt.new(user, 'CODE 2', 'two/two.py').save
    attempt = Attempt.new(user, 'CODE 3', 'two/two.rb').save
    assert_equal attempt.previous_submission, user.submissions.first
  end

  def test_newlines_are_removed_at_the_end_of_the_file
    Attempt.new(user, "CODE1\n\nCODE2\n\n\n", 'two/two.rb').save
    assert_equal "CODE1\n\nCODE2", user.submissions.first.code
  end

  def test_newlines_are_removed_at_the_beginning_of_the_file
    Attempt.new(user, "\nCODE1\n\nCODE2", 'two/two.rb').save
    assert_equal "CODE1\n\nCODE2", user.submissions.first.code
  end

  def test_rejects_duplicates
    first_attempt = Attempt.new(user, "CODE", 'two/two.rb').save
    second_attempt =  Attempt.new(user, "CODE", 'two/two.rb')

    assert second_attempt.duplicate?
  end

  def test_no_reject_without_previous
    attempt = Attempt.new(user, "CODE", 'two/two.rb')
    refute attempt.duplicate?
  end

  def test_attempt_sets_exercise_as_current
    attempt = Attempt.new(user, "CODE", 'two/two.rb').save
    assert user.working_on?(Exercise.new('ruby', 'two'))
  end

  def test_attempt_sets_completed_exercises_as_current
    refute user.working_on?(Exercise.new('ruby', 'one'))
    attempt = Attempt.new(user, "CODE", 'one/one.rb').save
    assert user.working_on?(Exercise.new('ruby', 'one'))
  end
end

