require_relative '../../integration_helper'

class AttemptTest < Minitest::Test
  include DBCleaner

  attr_reader :user
  def setup
    super
    @user = User.create
  end

  def test_saving_with_comments_creates_a_new_comment
    iteration = Iteration.new({ 'hello-world.ext' => 'CODE' }, 'fake', 'hello-world', comment: "hello world")

    attempt = Attempt.new(user, iteration).save

    assert_equal 1, Comment.count
    comment = Comment.first
    assert_equal "hello world", comment.body
    assert_equal attempt.user, comment.user
    assert_equal attempt.submission, comment.submission
  end

  def test_saving_without_comments_does_not_create_the_comment
    save_attempt = lambda do |i|
      Attempt.new(user, i).save
    end
    iteration = Iteration.new({ 'one.ext' => 'CODE' }, 'fake', 'one')
    save_attempt.call(iteration)
    assert_equal 0, Comment.count

    iteration = Iteration.new({ 'one.ext' => 'CODE' }, 'fake', 'one', comment: "")
    save_attempt.call(iteration)
    assert_equal 0, Comment.count
  end

  def test_saving_an_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard

    iteration = Iteration.new({ 'two.py' => 'CODE' }, 'python', 'two')
    Attempt.new(user, iteration).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.track_id
    assert_equal 'two', submission.slug
    assert_equal user, submission.user
  end

  def test_saving_a_multi_file_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard

    iteration = Iteration.new({ 'two.py' => 'CODE' }, 'python', 'two')
    Attempt.new(user, iteration).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.track_id
    assert_equal 'two', submission.slug
    assert_equal({ 'two.py' => 'CODE' }, submission.solution)
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_current_exercise
    assert_equal 0, Submission.count # guard

    iteration = Iteration.new({ 'two.py' => 'CODE' }, 'python', 'two')
    Attempt.new(user, iteration).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.track_id
    assert_equal 'two', submission.slug
    assert_equal user, submission.user
  end

  def test_an_attempt_includes_the_code_and_filename_in_the_submissions_solution
    iteration = Iteration.new({ 'two.py' => 'CODE' }, 'python', 'two')
    Attempt.new(user, iteration).save
    assert_equal({ 'two.py' => 'CODE' }, user.submissions.first.reload.solution)
  end

  def test_previous_submission_after_first_attempt
    iteration = Iteration.new({ 'two.py' => 'CODE' }, 'python', 'two')
    attempt = Attempt.new(user, iteration).save
    assert_equal attempt.previous_submission.class, NullSubmission
  end

  def test_previous_submission_after_first_attempt_in_new_language
    Attempt.new(user, Iteration.new({ 'two.py' => 'CODE 1' }, 'python', 'two')).save
    attempt = Attempt.new(user, Iteration.new({ 'two.py' => 'CODE 2' }, 'python', 'two')).save
    assert_equal attempt.previous_submission.track_id, "python"
  end

  def test_previous_submission
    Attempt.new(user, Iteration.new({ 'two.py' => 'CODE 1' }, 'python', 'two')).save
    attempt = Attempt.new(user, Iteration.new({ 'two.py' => 'CODE 2' }, 'python', 'two')).save
    assert_equal attempt.previous_submission, Submission.first
  end

  def test_previous_submission_with_new_language_sandwich
    Attempt.new(user, Iteration.new({ 'two.rb' => 'CODE 1' }, 'ruby', 'two')).save
    Attempt.new(user, Iteration.new({ 'two.py' => 'CODE 2' }, 'python', 'two')).save
    attempt = Attempt.new(user, Iteration.new({ 'two.rb' => 'CODE 3' }, 'ruby', 'two')).save

    assert_equal attempt.previous_submission, Submission.first
  end

  def test_newlines_are_removed_at_the_end_of_the_file
    Attempt.new(user, Iteration.new({ 'two.rb' => "CODE1\n\nCODE2\n\n\n" }, 'ruby', 'two')).save
    assert_equal "CODE1\n\nCODE2", user.submissions.first.solution.first.last
  end

  def test_newlines_are_removed_at_the_beginning_of_the_file
    Attempt.new(user, Iteration.new({ 'two.rb' => "\nCODE1\n\nCODE2" }, 'ruby', 'two')).save
    assert_equal "CODE1\n\nCODE2", user.submissions.first.solution.first.last
  end

  def test_rejects_duplicates
    Attempt.new(user, Iteration.new({ 'two.py' => 'CODE' }, 'python', 'two')).save
    attempt = Attempt.new(user, Iteration.new({ 'two.py' => 'CODE' }, 'python', 'two')).save

    assert attempt.duplicate?
  end

  def test_does_not_reject_empty_first_submission_as_duplicate
    attempt = Attempt.new(user, Iteration.new({ 'two.py' => '' }, 'python', 'two')).save

    refute attempt.duplicate?
  end

  def test_no_reject_without_previous
    attempt = Attempt.new(user, Iteration.new({ 'two.py' => 'CODE' }, 'python', 'two')).save
    refute attempt.duplicate?
  end
end
