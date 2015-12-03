require_relative '../../integration_helper'

class AttemptTest < Minitest::Test
  include DBCleaner

  attr_reader :user
  def setup
    super
    @user = User.create
  end

  def python_two
    {'python/two/two.py' => 'CODE'}
  end

  def test_validity
    X::Exercise.stub(:exists?, true) do
      refute Attempt.new(user, Iteration.new('two.py' => 'CODE')).valid?
      assert Attempt.new(user, Iteration.new(python_two)).valid?
    end

    X::Exercise.stub(:exists?, false) do
      refute Attempt.new(user, Iteration.new(python_two)).valid?
    end
  end

  def test_saving_an_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard

    Attempt.new(user, Iteration.new(python_two)).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.track_id
    assert_equal 'two', submission.slug
    assert_equal user, submission.user
  end

  def test_saving_a_multi_file_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard

    Attempt.new(user, Iteration.new(python_two)).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.track_id
    assert_equal 'two', submission.slug
    assert_equal python_two, submission.solution
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_current_exercise
    assert_equal 0, Submission.count # guard

    Attempt.new(user, Iteration.new(python_two)).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.track_id
    assert_equal 'two', submission.slug
    assert_equal user, submission.user
  end

  def test_an_attempt_includes_the_code_and_filename_in_the_submissions_solution
    Attempt.new(user, Iteration.new('two/two.py' => 'CODE 123')).save
    assert_equal({'two/two.py' => 'CODE 123'}, user.submissions.first.reload.solution)
  end

  def test_previous_submission_after_first_attempt
    attempt = Attempt.new(user, Iteration.new('two/two.rb' => 'CODE')).save
    assert_equal attempt.previous_submission.class, NullSubmission
  end

  def test_previous_submission_after_first_attempt_in_new_language
    Attempt.new(user, Iteration.new('ruby/two/two.rb' => 'CODE 1')).save
    attempt = Attempt.new(user, Iteration.new('python/two/two.py' => 'CODE 2')).save
    assert_equal attempt.previous_submission.track_id, "python"
  end

  def test_previous_submission
    Attempt.new(user, Iteration.new('two/two.rb' => 'CODE 1')).save
    one = Submission.first
    attempt = Attempt.new(user, Iteration.new('two/two.rb' => 'CODE 2')).save
    assert_equal attempt.previous_submission, one
  end

  def test_previous_submission_with_new_language_sandwich
    Attempt.new(user, Iteration.new('two/two.rb' => 'CODE 1')).save
    Attempt.new(user, Iteration.new('two/two.py' => 'CODE 2')).save
    attempt = Attempt.new(user, Iteration.new('two/two.rb' => 'CODE 3')).save
    assert_equal attempt.previous_submission, user.submissions.first
  end

  def test_newlines_are_removed_at_the_end_of_the_file
    Attempt.new(user, Iteration.new('two/two.rb' => "CODE1\n\nCODE2\n\n\n")).save
    assert_equal "CODE1\n\nCODE2", user.submissions.first.solution.first.last
  end

  def test_newlines_are_removed_at_the_beginning_of_the_file
    Attempt.new(user, Iteration.new('ruby/two/two.rb' => "\nCODE1\n\nCODE2")).save
    assert_equal "CODE1\n\nCODE2", user.submissions.first.solution.first.last
  end

  def test_rejects_duplicates
    Attempt.new(user, Iteration.new('ruby/two/two.rb' => "CODE")).save
    attempt = Attempt.new(user, Iteration.new('ruby/two/two.rb' => 'CODE'))

    assert attempt.duplicate?
  end

  def test_does_not_reject_empty_first_submission_as_duplicate
    attempt = Attempt.new(user, Iteration.new('ruby/two/two.rb' => '')).save

    refute attempt.duplicate?
  end

  def test_no_reject_without_previous
    attempt = Attempt.new(user, Iteration.new('ruby/two/two.rb' => 'CODE'))
    refute attempt.duplicate?
  end
end

