require_relative '../integration_helper'
require "mocha/setup"

class SubmissionTest < Minitest::Test
  include DBCleaner

  def exercise
    Exercise.new('ruby', 'one')
  end

  def submission
    @submission ||= begin
      Submission.on(exercise).tap do |submission|
        submission.user = User.create(username: 'charlie')
        submission.save
      end
    end
  end

  def alice
    @alice ||= User.create(username: 'alice')
  end

  def fred
    @fred ||= User.create(username: 'fred')
  end

  def teardown
    super
    @submission = nil
    @fred = nil
    @alice = nil
  end

  def test_random_submission_key
    submission = Submission.create(user: alice)
    submission.reload
    refute_nil submission.key
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

  def test_supersede_completed_submissions
    submission.state = 'done'
    submission.done_at = Time.now
    submission.save
    submission.supersede!
    assert_equal 'superseded', submission.state
    assert_nil   submission.done_at
  end

  def test_like_sets_is_liked
    submission = Submission.new(state: 'pending')
    submission.like!(alice)
    assert submission.is_liked = true
  end

  def test_like_sets_liked_by
    submission = Submission.create(state: 'pending', user: alice)
    submission.like!(fred)
    assert_equal [fred], submission.liked_by
  end

  def test_like_calls_mute
    submission = Submission.create(state: 'pending', user: alice)
    submission.expects(:mute).with(fred)
    submission.like!(fred)
  end

  def test_unlike_resets_is_liked_if_liked_by_is_empty
    submission = Submission.create(state: 'pending', user: alice)
    Like.create(submission: submission, user: fred)
    submission.unlike!(fred)
    refute submission.is_liked
  end

  def test_unlike_does_not_reset_is_liked_if_liked_by_is_not_empty
    bob = User.create(username: 'bob')
    submission = Submission.create(state: 'pending', user: alice)
    Like.create(submission: submission, user: bob)
    Like.create(submission: submission, user: fred)
    submission.unlike!(bob)
    assert submission.is_liked
  end

  def test_unlike_changes_liked_by
    submission = Submission.create(state: 'pending', user: alice)
    Like.create(submission: submission, user: fred)
    submission.unlike!(fred)
    assert_equal [], submission.liked_by
  end

  def test_unlike_calls_unmute
    submission = Submission.create(state: 'pending', user: alice)
    submission.expects(:unmute).with(fred)
    submission.unlike!(fred)
  end

  def test_liked_reflects_positive_is_liked
    submission = Submission.new(is_liked: true)
    assert submission.liked?
  end

  def test_liked_reflects_negative_is_liked
    submission = Submission.new(is_liked: false)
    refute submission.liked?
  end

  def test_muted_by_when_muted
    submission = Submission.create(user: fred, state: 'pending')
    submission.mute! alice
    assert submission.muted_by?(alice)
  end

  def test_unmuted_for_when_muted
    submission.mute(submission.user)
    submission.save
    refute(Submission.unmuted_for(submission.user).include?(submission),
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

    assert_equal %w(alice bob charlie), submission.viewers.map(&:username)
    assert_equal 3, submission.view_count
  end

  def test_viewing_submission_twice_is_fine
    alice = User.create(username: 'alice')
    submission.viewed!(alice)
    submission.viewed!(alice)
    assert_equal 1, submission.view_count
    assert_equal %w(alice), submission.viewers.map(&:username)
  end

  def test_viewing_with_increase_in_viewers
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    submission.viewed!(alice)
    assert_equal 1, submission.view_count
    submission.viewed!(bob)
    assert_equal 2, submission.view_count
  end

  def test_comments_are_sorted
    submission.comments << Comment.new(body: 'second', created_at: Time.now, user: submission.user)
    submission.comments << Comment.new(body: 'first', created_at: Time.now - 1000, user: submission.user)
    submission.save

    one, two = submission.comments
    assert_equal 'first', one.body
    assert_equal 'second', two.body
  end

  def test_aging_submissions
    # not old
    s1 = Submission.create(user: alice, state: 'pending')
    # no nits
    s2 = Submission.create(user: alice, state: 'pending', created_at: (Date.today - 22).to_time, nit_count: 0)
    # not pending
    s3 = Submission.create(user: alice, state: 'completed')
    s4 = Submission.create(user: alice, state: 'pending', created_at: (Date.today - 22).to_time, nit_count: 1)

    # Guard clause.
    # All the expected submissions got created
    assert_equal 4, Submission.count

    ids = Submission.aging.map(&:id)
    assert_equal [s4.id], ids
  end
end
