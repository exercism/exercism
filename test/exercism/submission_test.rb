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

  def test_do_not_supersede_completed_submissions
    submission.state = 'done'
    submission.save
    submission.supersede!
    assert_equal 'done', submission.state
  end

  def test_not_completed_when_ongoing
    submission.state = 'pending'
    submission.save
    assert !Submission.assignment_completed?(submission), 'The submission should totally be ongoing here'
  end

  def test_completed_when_completed
    submission.state = 'done'
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

  def test_participants
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    charlie = User.create(username: 'charlie')
    s1 = Submission.create(state: 'superseded', user: alice, language: 'nong', slug: 'one')
    s1.comments << Comment.new(user: bob, comment: 'nice')
    s1.save
    s2 = Submission.create(state: 'pending', user: alice, language: 'nong', slug: 'one')
    s2.comments << Comment.new(user: charlie, comment: 'pretty good')
    s2.save

    assert_equal %w(alice bob charlie), s2.participants.map(&:username).sort
  end

  def test_participants_with_mentions
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    charlie = User.create(username: 'charlie')
    mention_user = User.create(username: 'mention_user')
    s1 = Submission.create(state: 'superseded', user: alice, language: 'nong', slug: 'one')
    s1.comments << Comment.new(user: alice, comment: 'What about @bob?')
    s1.save
    s2 = Submission.create(state: 'pending', user: alice, language: 'nong', slug: 'one')
    s2.comments << Comment.new(user: charlie, comment: '@mention_user should have bleh')
    s2.save

    # NOTE: mention_user doesn't enter until s2, but it's related to s1.
    assert_equal %w(alice bob charlie mention_user), s1.participants.map(&:username).sort
    assert_equal %w(alice bob charlie mention_user), s2.participants.map(&:username).sort
  end

  def test_muted_by_when_muted
    submission = Submission.new(state: 'pending', muted_by: ['alice'])
    assert submission.muted_by?(alice)
  end

  def test_unmuted_for_when_muted
    submission.mute(submission.user.username)
    submission.save
    refute(Submission.unmuted_for(submission.user.username).include?(submission),
           "unmuted_for should only return submissions that have not been muted")
  end

  def test_muted_by_when_not_muted
    submission = Submission.new(state: 'pending')
    refute submission.muted_by?(alice)
  end

  def test_submissions_with_no_views
    assert_empty submission.viewers
    assert_equal 0, submission.view_count
  end

  def test_viewed_submission
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    charlie = User.create(username: 'charlie')
    submission.viewed!(alice)
    submission.viewed!(bob)
    submission.viewed!(charlie)
    submission.viewed!(bob)
    submission.reload

    assert_equal %w(alice bob charlie), submission.viewers
    assert_equal 3, submission.view_count
  end
end

