require './test/integration_helper'
require 'mocha/setup'

class WorkTest < Minitest::Test
  include DBCleaner

  def test_work_where_alice_has_commented
    alice = User.create(username: 'alice', completed: { ruby: [:anything] })
    bob = User.create(username: 'bob')
    submission = Submission.create(user: bob, language: 'ruby', slug: 'anything')
    Comment.create(user: bob, submission: submission, body: 'something')
    Comment.create(user: alice, submission: submission, body: 'something')

    assert_nil Work.new(alice).random
  end

  def test_work_where_alice_has_not_commented
    alice = User.create(username: 'alice', completed: { ruby: [:anything] })
    bob = User.create(username: 'bob')
    submission = Submission.create(user: bob, language: 'ruby', slug: 'anything')

    assert_equal submission, Work.new(alice).random
  end

  def test_no_completed_exercises
    user = User.create(completed: {})
    work = Work.new(user)
    assert_nil work.random
  end

  def test_completed_exercise_latest_first_in_70_percent_of_cases
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    sub1 = Submission.create(state: 'pending', user: bob, language: 'python', slug: 'one')
    sub2 = Submission.create(state: 'pending', user: alice, language: 'python', slug: 'two')

    user = User.create(completed: { python: [:one, :two]})

    work = Work.new(user)
    work.stubs(:rand).returns(0.6)
    assert_equal sub2, work.random
  end

  def test_completed_exercise_random_first_in_30_percent_of_cases
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    sub1 = Submission.create(state: 'pending', user: bob, language: 'python', slug: 'one')
    sub2 = Submission.create(state: 'pending', user: alice, language: 'python', slug: 'two')

    user = User.create(completed: { python: [:one, :two]})
    user.completed[:python].expects(:shuffle).returns([:one, :two])

    work = Work.new(user)
    work.stubs(:rand).returns(0.8)
    assert_equal work.random, sub1
  end

  def test_dont_suggest_submissions_user_has_already_liked
    alice = User.create(username: 'alice')
    submission = Submission.create(state: 'pending', user: alice, language: 'haskell', slug: 'two')

    user = User.create(completed: { haskell: [:one, :two]})
    Like.create(submission: submission, user: user)
    work = Work.new(user)
    assert_nil work.random
  end

  def test_still_suggest_submissions_user_hasnt_already_liked
    alice = User.create(username: 'alice')
    sub1 = Submission.create(state: 'pending', user: alice, language: 'haskell', slug: 'one')
    sub2 = Submission.create(state: 'pending', user: alice, language: 'haskell', slug: 'two')

    user = User.create(completed: { haskell: [:one, :two]})
    Like.create(submission: sub2, user: user)
    work = Work.new(user)
    assert_equal sub1, work.random
  end

end
