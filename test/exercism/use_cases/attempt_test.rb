require './test/integration_helper'

class AttemptTest < MiniTest::Unit::TestCase

  attr_reader :user, :curriculum
  def setup
    @user = User.create(current: {'nong' => 'one', 'femp' => 'one'})
    @curriculum = Curriculum.new('/tmp')
    nong = Locale.new('nong', 'no', 'not')
    femp = Locale.new('femp', 'fp', 'fpt')
    @curriculum.add(nong, ['one'])
    @curriculum.add(femp, ['one'])
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

  def test_a_new_attempt_supercedes_the_previous_one
    Attempt.new(user, 'CODE 1', 'one.fp', curriculum).save
    Attempt.new(user, 'CODE 2', 'one.fp', curriculum).save
    one, two = user.submissions
    assert_equal 'superceded', one.reload.state
    assert_equal 'pending', two.reload.state
  end

  def test_an_attempt_does_not_supercede_other_languages
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

end

