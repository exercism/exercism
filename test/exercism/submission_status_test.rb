require_relative '../test_helper'
require_relative '../integration_helper'
require_relative '../../lib/exercism/user'
require_relative '../../lib/exercism/submission'

class SubmissionStatusTest < Minitest::Test
  include DBCleaner

  def setup
    super
    %w(alice frank junior sam kimo).each do |username|
      instance_variable_set("@#{username}", User.create(username: username))
    end

    @problem = Problem.new('scala', 'pancakes')

    @alice.submissions << new_done_submission
    @frank.submissions << new_done_submission
    @kimo.submissions << new_working_submission
    @junior.submissions << new_working_submission
  end

  def new_done_submission
    submission = Submission.on(@problem)
    submission.state = 'done'
    submission
  end

  def new_working_submission
    submission = Submission.on(@problem)
    submission.state = 'pending'
    submission
  end

  def test_returns_users_who_are_working_on_problem
    users = SubmissionStatus.users_who_are_working_on_submission_for(@problem)
    assert users.find_by(id: @kimo.id), "Kimo is working on the problem but was not included in the list"
    assert users.find_by(id: @junior.id), "Junior is working on the problem but was not included in the list"
    assert users.find_by(id: @alice.id).nil?, "Return Alice even though she is done with the problem"
    assert users.find_by(id: @frank.id).nil?, "Return Frank even though she is done with the problem"
  end

  def test_returns_users_who_completed_the_problem
    users = SubmissionStatus.users_who_have_completed(@problem)
    assert users.find_by(id: @kimo.id).nil?, "Kimo is working on the problem but was returned as completed"
    assert users.find_by(id: @junior.id).nil?, "Kimo is working on the problem but was returned as completed"
    assert users.find_by(id: @alice.id), "Return Alice even though she is done with the problem"
    assert users.find_by(id: @frank.id), "Return Frank even though she is done with the problem"
  end

  def test_whether_a_user_has_completed_a_problem
    assert SubmissionStatus.is_user_done_with?(@alice, @problem), "Alice is done but returned false"
    assert SubmissionStatus.is_user_done_with?(@frank, @problem), "Frank is done but returned false"

    assert !SubmissionStatus.is_user_done_with?(@kimo, @problem), "Kimo is not done but returned true"
    assert !SubmissionStatus.is_user_done_with?(@junior, @problem), "Junior is not done but returned true"
  end

  def test_whether_a_user_is_working_on_problem
    assert SubmissionStatus.is_user_working_on?(@kimo, @problem), "Kimo is still working on the problem but returned false"
    assert SubmissionStatus.is_user_working_on?(@junior, @problem), "Junior is still working on the problem but returned false"

    assert !SubmissionStatus.is_user_working_on?(@alice, @problem), "Alice is not working on the problem but returned false"
    assert !SubmissionStatus.is_user_working_on?(@frank, @problem), "Frank is not working on the problem but returned false"
  end

  def test_returns_completed_submissions
    completed_submissions = SubmissionStatus.done_submissions
    assert completed_submissions.where(user_id: @alice.id).exists?, "Did not return Alice's submission"
    assert completed_submissions.where(user_id: @frank.id).exists?, "Did not return Frank's submission"

    assert completed_submissions.where(user_id: @kimo.id).empty?, "Return Kimo's submission as done"
    assert completed_submissions.where(user_id: @junior.id).empty?, "Return Junior's submission as done"
  end

  def test_returns_submissions_completed_for_specific_problem
    completed_submissions = SubmissionStatus.submissions_completed_for(@problem)
    assert completed_submissions.where(user_id: @alice.id).exists?, "Did not return Alice's submission"
    assert completed_submissions.where(user_id: @frank.id).exists?, "Did not return Frank's submission"

    assert completed_submissions.where(user_id: @kimo.id).empty?, "Return Kimo's submission as done"
    assert completed_submissions.where(user_id: @junior.id).empty?, "Return Junior's submission as done"

    submissions_for_fake_problem = SubmissionStatus.submissions_completed_for(Problem.new("scala", "waffles"))
    assert submissions_for_fake_problem.empty?, "Return submissions for a fake problem"
  end

end
