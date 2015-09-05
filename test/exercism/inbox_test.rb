require_relative '../integration_helper'

class InboxTrackTest < Minitest::Test
  include DBCleaner

  # This tests the data for Alice's inbox.
  def test_inbox
    # Alice is a mentor in elixir, and is therefore authorized to see everything in that track.
    # In Go she can see only what she has submitted (Leap and Hamming, but not Clock).
    # Her own exercises appear in the inbox.
    # We won't bother with Bob's views and ACLs, since we're not testing his inbox.
    alice = User.create(username: 'alice', avatar_url: 'alice.jpg', mastery: ['elixir'])
    bob = User.create(username: 'bob', avatar_url: 'bob.jpg')

    [
      {user: bob, language: 'elixir', slug: 'triangle', archived: false, auth: true, viewed: -1},
      {user: bob, language: 'elixir', slug: 'anagram', archived: false, auth: true, viewed: -1},
      {user: bob, language: 'elixir', slug: 'word-count', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'leap', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'clock', archived: false, auth: false, viewed: -1},
      {user: alice, language: 'go', slug: 'leap', archived: true, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'hamming', archived: true, auth: true, viewed: -1},
      {user: alice, language: 'go', slug: 'hamming', archived: false, auth: true, viewed: +1},
    ].each.with_index do |exercise, i|
      ts = i.days.ago
      auth = exercise.delete(:auth)
      viewed_diff_in_seconds = exercise.delete(:viewed)

      exercise = UserExercise.create(exercise.merge(last_activity_at: ts))
      if auth
        ACL.authorize(alice, exercise.problem)
      end

      View.create(user_id: alice.id, exercise_id: exercise.id, last_viewed_at: ts+viewed_diff_in_seconds)
    end

    elixir1 = Inbox.new(alice, 'elixir')
    elixir1.per_page = 2
    elixir2 = Inbox.new(alice, 'elixir', 2)
    elixir2.per_page = 2
    go = Inbox.new(alice, 'go')

    assert_equal 2, elixir1.exercises.size
    assert_equal 1, elixir2.exercises.size
    assert_equal 2, go.exercises.size

    ex1, ex2 = elixir1.exercises
    ex3 = elixir2.exercises.first
    ex4, ex5 = go.exercises

    assert_equal 'bob', ex1.username
    assert_equal 'bob.jpg', ex1.avatar_url
    assert_equal 'Triangle', ex1.problem.name
    assert_equal 'elixir', ex1.problem.track_id
    assert ex1.unread

    assert_equal 'bob', ex2.username
    assert_equal 'bob.jpg', ex2.avatar_url
    assert_equal 'Anagram', ex2.problem.name
    assert_equal 'elixir', ex2.problem.track_id
    assert ex2.unread

    assert_equal 'bob', ex3.username
    assert_equal 'bob.jpg', ex3.avatar_url
    assert_equal 'Word Count', ex3.problem.name
    assert_equal 'elixir', ex3.problem.track_id
    refute ex3.unread

    assert_equal 'bob', ex4.username
    assert_equal 'bob.jpg', ex4.avatar_url
    assert_equal 'Leap', ex4.problem.name
    assert_equal 'go', ex4.problem.track_id
    refute ex4.unread

    assert_equal 'alice', ex5.username
    assert_equal 'alice.jpg', ex5.avatar_url
    assert_equal 'Hamming', ex5.problem.name
    assert_equal 'go', ex5.problem.track_id
    refute ex5.unread
  end
end
