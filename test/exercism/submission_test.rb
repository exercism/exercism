require './test/integration_helper'
require "mocha/setup"

class NongCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('nong', 'no', 'not')
  end
end

class SubmissionTest < Minitest::Test

  def exercise
    Exercise.new('nong', 'one')
  end

  def submission
    return @submission if @submission

    @submission = Submission.on(exercise)
    @submission.user = User.create(username: 'charlie')
    @submission.save
    @submission
  end

  def alice
    return @alice if @alice
    @alice = Object.new
    def @alice.username
      'alice'
    end
    @alice
  end

  def teardown
    Mongoid.reset
    @submission = nil
  end

  def test_supersede_pending_submission
    assert_equal 'pending', submission.state
    submission.supersede!
    submission.reload
    assert_equal 'superseded', submission.state
  end

  def test_supersede_hibernating_submission
    submission.state = 'hibernating'
    submission.supersede!
    submission.reload
    assert_equal 'superseded', submission.state
  end

  def test_supersede_tweaked_submission
    submission.state = 'tweaked'
    submission.supersede!
    submission.reload
    assert_equal 'superseded', submission.state
  end

  def test_do_not_supersede_approved_submissions
    submission.state = 'approved'
    submission.save
    submission.supersede!
    assert_equal 'approved', submission.state
  end

  def test_not_completed_when_ongoing
    submission.state = 'pending'
    submission.save
    assert !Submission.assignment_completed?(submission), 'The submission should totally be ongoing here'
  end

  def test_completed_when_completed
    submission.state = 'approved'
    submission.save
    assert Submission.assignment_completed?(submission), 'The submission should totally be ongoing here'
  end

  def test_retrieve_assignment
    # Crazy long path. Best I can figure there's no storage of the path past the
    # Curriculum object in Exercism so we have to mock the whole chain
    trail = mock()
    Exercism.stubs(:current_curriculum => mock(:trails => trail))
    trail.expects(:[]).with('ruby').returns(mock(:assign => mock(:example => "say 'one'")))

    submission = Submission.new(slug: 'bob', language: 'ruby')
    assert_equal("say 'one'", submission.assignment.example)
  end

  def test_iteration_counts
    alice = User.new(username: 'alice')
    s1 = Submission.create(state: 'superseded', user: alice, language: 'nong', slug: 'one')
    s2 = Submission.create(state: 'superseded', user: alice, language: 'nong', slug: 'one')
    s3 = Submission.create(state: 'pending', user: alice, language: 'nong', slug: 'one')

    [s1, s2, s3].each do |submission|
      assert_equal 3, submission.versions_count
    end

    assert_equal 1, s1.version
    assert_equal 2, s2.version
    assert_equal 3, s3.version
  end

  def test_participants_when_not_approved
    alice = User.new(username: 'alice')
    bob = User.new(username: 'bob', github_id: '2', mastery: ['nong'])
    s1 = Submission.create(state: 'pending', user: alice, language: 'nong', slug: 'one')

    assert_equal Set.new([alice]), s1.participants
  end

  def test_muted_by_when_muted
    submission = Submission.new(state: 'pending', muted_by: ['alice'])
    assert submission.muted_by?(alice)
  end

  def test_muted_by_when_not_muted
    submission = Submission.new(state: 'pending')
    refute submission.muted_by?(alice)
  end
end

