require_relative '../../integration_helper'

class AttemptTest < Minitest::Test
  include DBCleaner

  attr_reader :user
  def setup
    super
    @user = User.create
  end

  def test_validity
    Xapi.stub(:exists?, true) do
      refute Attempt.new(user, 'CODE', 'two.py').valid?
      solution = { "ruby/two/two.py" => "CODE" }
      opts = { track: "ruby", slug: "two" }
      assert_equal true, Attempt.new(user, Iteration.new(solution, opts)).valid?
    end

    Xapi.stub(:exists?, false) do
      refute Attempt.new(user, 'CODE', 'python/two/two.py').valid?
    end
  end

  def test_saving_an_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard

    solution = {'python/two/two.py' => 'CODE'}
    opts = {code_analysis: 'a1', test_analysis: 't', track: 'python' , slug: 'two'}
    Attempt.new(user, Iteration.new(solution, opts)).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.track_id
    assert_equal 'two', submission.slug
    assert_equal user, submission.user
  end

  def test_saving_a_multi_file_attempt_constructs_a_submission
    assert_equal 0, Submission.count # guard
    solution = {'python/two/two.py' => 'CODE'}

    opts = {code_analysis: 'a1', test_analysis: 't', track: 'python' ,slug: 'two'}
		
    Attempt.new(user, nil, nil, Iteration.new(solution, opts)).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'python', submission.track_id
    assert_equal 'two', submission.slug
    assert_equal solution, submission.solution
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_current_exercise
    assert_equal 0, Submission.count # guard
    solution = {'ruby/two/two.rb' => 'CODE'}
    
    opts = {code_analysis: 'a1', test_analysis: 't', track: 'ruby' ,slug: 'two'}
		
    Attempt.new(user, 'CODE', 'ruby/two/two.rb', Iteration.new(solution, opts)).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'ruby', submission.track_id
    assert_equal 'two', submission.slug
    assert submission.pending?
    assert_equal user, submission.user
  end

  def test_attempt_is_created_for_completed_exercise
    assert_equal 0, Submission.count # guard

    Attempt.new(user, Iteration.new({'ruby/one/one.rb' => 'CODE'}, {track: 'ruby', slug: 'one'})).save

    assert_equal 1, Submission.count
    submission = Submission.first
    assert_equal 'ruby', submission.track_id
    assert_equal 'one', submission.slug
    assert submission.pending?, "Expected submission to be pending but was #{submission.state}"
    assert_equal user, submission.user
  end

  def test_a_new_attempt_supersedes_the_previous_one
    Attempt.new(user, 'CODE 1', 'ruby/two/two.rb').save
    Attempt.new(user, 'CODE 2', 'ruby/two/two.rb').save
    one = Submission.find_by(code: 'CODE 1')
    two = Submission.find_by(code: 'CODE 2')
    assert_equal 'superseded', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_a_new_attempt_supersedes_the_previous_hibernating_one
    submission = Submission.create(user: user, code: 'CODE 1', language: 'ruby', slug: 'two', created_at: Time.now, state: 'hibernating')
    solution = {'ruby/two/two.rb' => 'CODE 2'}
    opts = {track: 'ruby', slug: 'two'}
    Attempt.new(user, Iteration.new(solution, opts)).save
    one = Submission.find_by(code: 'CODE 1')
    two = Submission.find_by(code: 'CODE 2')
    assert_equal true, one.superseded?
    assert_equal true, two.pending?
  end

  def test_a_new_attempt_unmutes_previous_attempt
    tom = User.create(username: 'tom')
    jerry = User.create(username: 'jerry')
    submission = Submission.create(user: user, language: 'ruby', slug: 'two', created_at: Time.now)
    submission.mute! tom
    submission.mute! jerry
    Attempt.new(user, Iteration.new({'ruby/two/two.rb' => 'CODE'}, {track: 'ruby', slug: 'two'})).save
    assert_equal [], submission.reload.muted_by
  end

  def test_an_attempt_does_not_supersede_other_languages
    Attempt.new(user, Iteration.new({'two/two.py' => 'CODE 1'}, {track: 'python', slug: 'two'})).save
    Attempt.new(user, Iteration.new({'one/one.rb' => 'CODE 2'}, {track: 'ruby', slug: 'one'})).save
    one = Submission.find_by(code: 'CODE 1')
    two = Submission.find_by(code: 'CODE 2')
    assert_equal 'pending', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_an_attempt_includes_the_code_in_the_submission
    Attempt.new(user, 'CODE 123', 'two/two.py').save
    assert_equal 'CODE 123', user.submissions.first.reload.code
  end

  def test_an_attempt_includes_the_code_and_filename_in_the_submissions_solution
    Attempt.new(user, 'CODE 123', 'two/two.py').save
    assert_equal({'two/two.py' => 'CODE 123'}, user.submissions.first.reload.solution)
  end

  def test_previous_submission_after_first_attempt
    attempt = Attempt.new(user, 'CODE', 'two/two.rb').save
    assert_equal attempt.previous_submission.class, NullSubmission
  end

  def test_previous_submission_after_first_attempt_in_new_language
    opts = {code_analysis: 'a1', test_analysis: 't', track: 'ruby' ,slug: 'two'}
    solution = {'ruby/two/two.rb' => 'CODE 1'}
    Attempt.new(user, Iteration.new(solution, opts)).save
    attempt = Attempt.new(user, Iteration.new({'python/two/two.py' => 'CODE 2'}, 
    {code_analysis: 'a1', test_analysis: 't', track: 'python' ,slug: 'two'})).save
    assert_equal attempt.previous_submission.track_id, "python"
  end

  def test_previous_submission_after_superseding
    Attempt.new(user, 'CODE 1', 'two/two.rb').save
    one = Submission.find_by(code: 'CODE 1')
    attempt = Attempt.new(user, 'CODE 2', 'two/two.rb').save
    assert_equal attempt.previous_submission, one
  end

  def test_previous_submission_with_new_language_sandwich
    Attempt.new(user, Iteration.new({'two/two.rb' => 'CODE 1'}, 
    {track: 'ruby', slug: 'two'})).save
    Attempt.new(user, Iteration.new({'two/two.py' => 'CODE 2'}, 
    {track: 'python', slug: 'two'})).save
    attempt = Attempt.new(user, Iteration.new({'ruby/two/two.rb' => 'CODE'}, 
    {track: 'ruby', slug: 'two'})).save
    assert_equal attempt.previous_submission, user.submissions.first
  end

  def test_newlines_are_removed_at_the_end_of_the_file
    Attempt.new(user, "CODE1\n\nCODE2\n\n\n", 'two/two.rb').save
    assert_equal "CODE1\n\nCODE2", user.submissions.first.code
  end

  def test_newlines_are_removed_at_the_beginning_of_the_file
    Attempt.new(user, "\nCODE1\n\nCODE2", 'ruby/two/two.rb').save
    assert_equal "CODE1\n\nCODE2", user.submissions.first.code
  end

  def test_rejects_duplicates
    first_attempt = Attempt.new(user, "CODE", 'ruby/two/two.rb').save
    second_attempt =  Attempt.new(user, "CODE", 'ruby/two/two.rb')

    assert second_attempt.duplicate?
  end

  def test_does_not_reject_empty_first_submission_as_duplicate
    attempt = Attempt.new(user, "", 'ruby/two/two.rb').save

    refute attempt.duplicate?
  end

  def test_no_reject_without_previous
    attempt = Attempt.new(user, "CODE", 'ruby/two/two.rb')
    refute attempt.duplicate?
  end

  def test_attempt_sets_exercise_as_current
    attempt = Attempt.new(user, Iteration.new({'ruby/two/two.rb' => 'CODE'}, {track: 'ruby', slug: 'two'})).save
    assert user.working_on?(Problem.new('ruby', 'two'))
  end

  def test_attempt_sets_completed_exercises_as_current
    refute user.working_on?(Problem.new('ruby', 'one'))
    solution = {'ruby/one/one.rb' => 'CODE'}
    opts = {track: 'ruby', slug: 'one'}
    Attempt.new(user, Iteration.new(solution, opts)).save
    assert_equal true, user.working_on?(Problem.new('ruby', 'one'))
  end
end

