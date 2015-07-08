require_relative '../integration_helper'
require 'mocha/setup'

class WorkTest < Minitest::Test
  include DBCleaner

  def test_work_where_alice_has_commented
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    submission = Submission.create(user: bob, language: 'ruby', slug: 'anything')
    Comment.create(user: bob, submission: submission, body: 'something')
    Comment.create(user: alice, submission: submission, body: 'something')

    assert_nil Work.new(alice).random
  end

  def test_work_where_alice_has_not_commented
    alice = User.create(username: 'alice')
    Submission.create(user: alice, language: 'ruby', slug: 'anything', state: 'done')

    bob = User.create(username: 'bob')
    submission = Submission.create(user: bob, language: 'ruby', slug: 'anything')

    assert_equal submission, Work.new(alice).random
  end

  def test_exclude_hello_world
    alice = User.create(username: 'alice', mastery: ['ruby'])
    bob = User.create(username: 'bob')
    Submission.create(user: alice, language: 'ruby', slug: 'hello-world', state: 'done')
    Submission.create(user: bob, language: 'ruby', slug: 'hello-world')

    assert_nil Work.new(alice).random
  end

  def test_exclude_hello_world_for_track_mentors
    alice = User.create(username: 'alice', mastery: ['ruby'])
    bob = User.create(username: 'bob')
    Submission.create(user: bob, language: 'ruby', slug: 'hello-world')

    assert_nil Work.new(alice).random
  end

  def test_work_where_alice_is_mentor
    alice = User.create(username: 'alice', mastery: ['ruby'])
    bob = User.create(username: 'bob')
    submission = Submission.create(user: bob, language: 'ruby', slug: 'word-count')

    assert_equal submission, Work.new(alice).random
  end

  def test_no_completed_exercises
    user = User.create
    work = Work.new(user)
    assert_nil work.random
  end

  def test_completed_exercise_latest_first_in_70_percent_of_cases
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    _ = Submission.create(state: 'pending', user: bob, language: 'python', slug: 'one')
    sub2 = Submission.create(state: 'pending', user: alice, language: 'python', slug: 'two')

    user = User.create
    Submission.create(state: 'done', user: user, language: 'python', slug: 'one')
    Submission.create(state: 'done', user: user, language: 'python', slug: 'two')

    work = Work.new(user)
    work.stubs(:rand).returns(0.6)
    assert_equal sub2, work.random
  end

  def test_completed_exercise_random_first_in_30_percent_of_cases
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    sub1 = Submission.create(state: 'pending', user: bob, language: 'python', slug: 'one')
    _ = Submission.create(state: 'pending', user: alice, language: 'python', slug: 'two')

    user = User.create
    Submission.create(state: 'done', user: user, language: 'python', slug: 'one')
    Submission.create(state: 'done', user: user, language: 'python', slug: 'two')

    work = Work.new(user)
    work.stubs(:rand).returns(0.8)
    work.send(:completed)['python'].expects(:shuffle).returns(['one', 'two'])
    assert_equal work.random, sub1
  end

  def test_dont_suggest_submissions_user_has_already_liked
    alice = User.create(username: 'alice')
    submission = Submission.create(state: 'pending', user: alice, language: 'haskell', slug: 'two')

    user = User.create
    Like.create(submission: submission, user: user)
    work = Work.new(user)
    assert_nil work.random
  end

  def test_still_suggest_submissions_user_hasnt_already_liked
    alice = User.create(username: 'alice')
    sub1 = Submission.create(state: 'pending', user: alice, language: 'haskell', slug: 'one')
    sub2 = Submission.create(state: 'pending', user: alice, language: 'haskell', slug: 'two')

    user = User.create
    Submission.create(state: 'done', user: user, language: 'haskell', slug: 'one')
    Submission.create(state: 'done', user: user, language: 'haskell', slug: 'two')

    Like.create(submission: sub2, user: user)
    work = Work.new(user)
    assert_equal sub1, work.random
  end

  def test_dont_suggest_submissions_user_has_submitted
    bob = User.create(username: "bob", mastery: ["ruby"])
    Submission.create(state: "pending", user: bob, language: "ruby", slug: "leap")

    assert_nil Work.new(bob).random
  end

end
