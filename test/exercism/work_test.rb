require_relative '../integration_helper'
require 'mocha/setup'

class WorkTest < Minitest::Test
  include DBCleaner

  def test_work_where_alice_has_commented
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    s1 = Submission.create(user: alice, language: 'ruby', slug: 'anything')
    UserExercise.create(user: alice, language: 'ruby', slug: 'anything', submissions: [s1])

    s2 = Submission.create(user: bob, language: 'ruby', slug: 'anything')
    UserExercise.create(user: bob, language: 'ruby', slug: 'anything', submissions: [s2])

    Comment.create(user: bob, submission: s2, body: 'something')
    Comment.create(user: alice, submission: s2, body: 'something')

    assert_nil Work.new(alice).random
  end

  def test_work_where_alice_has_not_commented
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    s1 = Submission.create(user: alice, language: 'ruby', slug: 'anything')
    UserExercise.create(user: alice, language: 'ruby', slug: 'anything', submissions: [s1])

    s2 = Submission.create(user: bob, language: 'ruby', slug: 'anything')
    UserExercise.create(user: bob, language: 'ruby', slug: 'anything', submissions: [s2])

    assert_equal s2, Work.new(alice).random
  end

  def test_exclude_hello_world
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    s1 = Submission.create(user: alice, language: 'ruby', slug: 'hello-world')
    UserExercise.create(user: alice, language: 'ruby', slug: 'hello-world', submissions: [s1])

    s2 = Submission.create(user: bob, language: 'ruby', slug: 'hello-world')
    UserExercise.create(user: bob, language: 'ruby', slug: 'hello-world', submissions: [s2])

    assert_nil Work.new(alice).random
  end

  def test_exclude_hello_world_for_track_mentors
    alice = User.create(username: 'alice', mastery: ['ruby'])
    bob = User.create(username: 'bob')

    s1 = Submission.create(user: alice, language: 'ruby', slug: 'hello-world')
    UserExercise.create(user: alice, language: 'ruby', slug: 'hello-world', submissions: [s1])

    s2 = Submission.create(user: bob, language: 'ruby', slug: 'hello-world')
    UserExercise.create(user: bob, language: 'ruby', slug: 'hello-world', submissions: [s2])

    assert_nil Work.new(alice).random
  end

  def test_work_where_alice_is_mentor
    alice = User.create(username: 'alice', mastery: ['ruby'])
    bob = User.create(username: 'bob')

    s1 = Submission.create(user: alice, language: 'ruby', slug: 'leap')
    UserExercise.create(user: alice, language: 'ruby', slug: 'leap', submissions: [s1])

    s2 = Submission.create(user: bob, language: 'ruby', slug: 'leap')
    UserExercise.create(user: bob, language: 'ruby', slug: 'leap', submissions: [s2])

    assert_equal s2, Work.new(alice).random
  end

  def test_no_completed_exercises
    user = User.create
    work = Work.new(user)
    assert_nil work.random
  end

  def test_completed_exercise_latest_first_in_70_percent_of_cases
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    s1 = Submission.create(user: alice, language: 'python', slug: 'one')
    UserExercise.create(user: alice, language: 'python', slug: 'one', submissions: [s1])

    s2 = Submission.create(user: bob, language: 'python', slug: 'two')
    UserExercise.create(user: bob, language: 'python', slug: 'two', submissions: [s2])

    user = User.create
    s3 = Submission.create(user: user, language: 'python', slug: 'one')
    UserExercise.create(user: user, language: 'python', slug: 'one', submissions: [s3])
    s4 = Submission.create(user: user, language: 'python', slug: 'two')
    UserExercise.create(user: user, language: 'python', slug: 'two', submissions: [s4])

    work = Work.new(user)
    work.stubs(:rand).returns(0.6)
    assert_equal s2, work.random
  end

  def test_exercise_random_first_in_30_percent_of_cases
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    s1 = Submission.create(user: bob, language: 'python', slug: 'one')
    UserExercise.create(user: bob, language: 'python', slug: 'one', submissions: [s1])
    s2 = Submission.create(user: alice, language: 'python', slug: 'two')
    UserExercise.create(user: bob, language: 'python', slug: 'two', submissions: [s2])

    user = User.create
    s3 = Submission.create(user: user, language: 'python', slug: 'one')
    s4 = Submission.create(user: user, language: 'python', slug: 'two')
    UserExercise.create(user: user, language: 'python', slug: 'one', submissions: [s3])
    UserExercise.create(user: user, language: 'python', slug: 'two', submissions: [s4])

    work = Work.new(user)
    work.stubs(:rand).returns(0.8)
    work.send(:submitted)['python'].expects(:shuffle).returns(['one', 'two'])
    assert_equal work.random, s1
  end

  def test_dont_suggest_submissions_user_has_liked
    alice = User.create(username: 'alice')
    submission = Submission.create(user: alice, language: 'haskell', slug: 'two')

    user = User.create
    Like.create(submission: submission, user: user)
    work = Work.new(user)
    assert_nil work.random
  end

  def test_still_suggest_submissions_user_hasnt_already_liked
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    s1 = Submission.create(user: alice, language: 'ruby', slug: 'anything')
    UserExercise.create(user: alice, language: 'ruby', slug: 'anything', submissions: [s1])

    s2 = Submission.create(user: bob, language: 'ruby', slug: 'anything')
    UserExercise.create(user: bob, language: 'ruby', slug: 'anything', submissions: [s2])

    Like.create(submission: s2, user: alice)
    work = Work.new(alice)
    assert_equal nil, work.random
  end

  def test_dont_suggest_the_users_own_submissions
    alice = User.create(username: 'alice', mastery: ['ruby'])

    s = Submission.create(user: alice, language: 'ruby', slug: 'anything')
    UserExercise.create(user: alice, language: 'ruby', slug: 'anything', submissions: [s])

    assert_nil Work.new(alice).random
  end

end
