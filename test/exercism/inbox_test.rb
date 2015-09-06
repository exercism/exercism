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
      {user: bob, language: 'go', slug: 'hello-world', archived: false, auth: true, viewed: -1},
      {user: bob, language: 'go', slug: 'leap', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'clock', archived: false, auth: false, viewed: -1},
      {user: alice, language: 'go', slug: 'leap', archived: true, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'hamming', archived: true, auth: true, viewed: -1},
      {user: bob, language: 'go', slug: 'anagram', archived: false, auth: true, viewed: -1, iteration_count: 0},
      {user: alice, language: 'go', slug: 'hamming', archived: false, auth: true, viewed: +1},
      {user: alice, language: 'go', slug: 'word-count', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'word-count', archived: false, auth: true, viewed: -1},
    ].each.with_index do |exercise, i|
      ts = i.days.ago
      auth = exercise.delete(:auth)
      viewed_diff_in_seconds = exercise.delete(:viewed)

      exercise[:iteration_count] ||= 1
      exercise = UserExercise.create(exercise.merge(last_activity_at: ts))
      if auth
        ACL.authorize(alice, exercise.problem)
      end

      View.create(user_id: alice.id, exercise_id: exercise.id, last_viewed_at: ts+viewed_diff_in_seconds)
    end

    elixir1 = Inbox.new(alice, 'elixir')
    elixir1.per_page = 2
    elixir2 = Inbox.new(alice, 'elixir', nil, 2)
    elixir2.per_page = 2
    go = Inbox.new(alice, 'go')
    wc = Inbox.new(alice, 'go', 'word-count')

    assert_equal 2, elixir1.exercises.size
    assert_equal 1, elixir2.exercises.size
    assert_equal 4, go.exercises.size
    assert_equal 2, wc.exercises.size

    ex1, ex2 = elixir1.exercises
    ex3 = elixir2.exercises.first
    ex4, ex5, ex6, ex7 = go.exercises
    ex8, ex9 = wc.exercises

    [
      [ex1, bob, 'Triangle', 'elixir', :unread],
      [ex2, bob, 'Anagram', 'elixir', :unread],
      [ex3, bob, 'Word Count', 'elixir', :read],
      [ex4, bob, 'Leap', 'go', :read],
      [ex5, alice, 'Hamming', 'go', :read],
      [ex6, alice, 'Word Count', 'go', :read],
      [ex7, bob, 'Word Count', 'go', :unread],
      [ex8, alice, 'Word Count', 'go', :read],
      [ex9, bob, 'Word Count', 'go', :unread],
    ].each do |ex, u, name, track_id, status|
      test_case = [u.username, track_id, name].join(" ")
      assert_equal u.username, ex.username, test_case
      assert_equal u.avatar_url, ex.avatar_url, test_case
      assert_equal name, ex.problem.name, test_case
      assert_equal track_id, ex.problem.track_id, test_case
      assert_equal status==:unread, ex.unread, test_case
    end
  end
end
