require_relative '../integration_helper'
require "mocha/setup"

class SubmissionTest < Minitest::Test
  include DBCleaner

  def problem
    Problem.new('ruby', 'one')
  end

  def submission
    @submission ||= problem_submission_for(User.create(username: 'charlie'))
  end

  def problem_submission_for(user)
    Submission.on(problem).tap do |submission|
      submission.user = user
      submission.save
    end
  end

  def create_submission
    Submission.create!(user: User.create!)
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

  def test_like_sets_is_liked
    submission = Submission.new
    submission.like!(alice)
    assert submission.is_liked = true
  end

  def test_like_sets_liked_by
    submission = Submission.create(user: alice)
    submission.like!(fred)
    assert_equal [fred], submission.liked_by
  end

  def test_unlike_resets_is_liked_if_liked_by_is_empty
    submission = Submission.create(user: alice)
    Like.create(submission: submission, user: fred)
    submission.unlike!(fred)
    refute submission.is_liked
  end

  def test_unlike_does_not_reset_is_liked_if_liked_by_is_not_empty
    bob = User.create(username: 'bob')
    submission = Submission.create(user: alice)
    Like.create(submission: submission, user: bob)
    Like.create(submission: submission, user: fred)
    submission.unlike!(bob)
    assert submission.is_liked
  end

  def test_unlike_changes_liked_by
    submission = Submission.create(user: alice)
    Like.create(submission: submission, user: fred)
    submission.unlike!(fred)
    assert_equal [], submission.liked_by
  end

  def test_liked_reflects_positive_is_liked
    submission = Submission.new(is_liked: true)
    assert submission.liked?
  end

  def test_liked_reflects_negative_is_liked
    submission = Submission.new(is_liked: false)
    refute submission.liked?
  end

  def test_comments_are_sorted
    submission.comments << Comment.new(body: 'second', created_at: Time.now, user: submission.user)
    submission.comments << Comment.new(body: 'first', created_at: Time.now - 1000, user: submission.user)
    submission.save

    one, two = submission.comments
    assert_equal 'first', one.body
    assert_equal 'second', two.body
  end

  def test_not_commented_on_by
    user = User.create!
    commented_on_by_user = create_submission
    Comment.create!(submission: commented_on_by_user, user: user, body: 'test')

    commented_on_by_someone_else = create_submission
    Comment.create!(submission: commented_on_by_someone_else, user: User.create!, body: 'test')

    not_commented_on_at_all = create_submission

    expected = [commented_on_by_someone_else, not_commented_on_at_all].sort
    assert_equal expected, Submission.not_commented_on_by(user).sort
  end

  def test_exercise_viewed_updates_single_record_per_user_and_exercise
    alice = User.create!(username: 'alice')
    bob = User.create!(username: 'bob')
    submission = Submission.create!(user: alice, language: 'rust', slug: 'pong')
    exercise = UserExercise.create!(user: alice, language: 'rust', slug: 'pong', submissions: [submission])
    submission.reload

    submission.viewed_by(alice)
    assert_equal 1, View.count

    v1 = View.first
    assert_equal alice.id, v1.user_id
    assert_equal exercise.id, v1.exercise_id
    refute_equal nil, v1.last_viewed_at

    yesterday = 1.day.ago
    v2 = View.create(user_id: bob.id, exercise_id: exercise.id, last_viewed_at: yesterday)

    submission.viewed_by(bob)
    assert_equal 2, View.count
    assert_in_delta 1, v2.last_viewed_at.to_i, Time.now.utc.to_i
  end
end
