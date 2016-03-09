require_relative '../integration_helper'

# override the slug order so it doesn't look it up from the x-api
class UserTrack
  def self.ordered_slugs(_)
    ['leap', 'hamming', 'word-count']
  end
end

class UserTrackTest < Minitest::Test
  include DBCleaner

  def setup
    super
    Language.instance_variable_set(:"@by_track_id", {"elixir" => "Elixir", "go" => "Go"})
  end

  def teardown
    super
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  # This tests the data for Alice's inbox sidebar.
  def test_user_tracks
    # Alice is a mentor in elixir, and is therefore authorized to see everything in that track.
    # In Go she can see only what she has submitted (Leap and Hamming, but not Clock).
    # Since she is not authorized to see Clock, that exercise should not be included either in
    # the total count or in the unread count.
    # Her own exercises appear in the inbox, and are included in the counts.
    # We won't bother with Bob's views and ACLs, since we're not testing his inbox.
    alice = User.create(username: 'alice', track_mentor: ['elixir'])
    bob = User.create(username: 'bob')

    [
      {user: alice, language: 'go', slug: 'leap', archived: true, auth: true, viewed: +1}, # No (archived)
      {user: alice, language: 'go', slug: 'hamming', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'leap', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'clock', archived: false, auth: false, viewed: -1}, # No (acl)
      {user: bob, language: 'go', slug: 'hamming', archived: true, auth: true, viewed: -1}, # No (archived)
      {user: bob, language: 'elixir', slug: 'triangle', archived: false, auth: true, viewed: -1},
      {user: alice, language: 'go', slug: 'word-count', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'word-count', archived: false, auth: true, viewed: -1},
      {user: bob, language: 'go', slug: 'hello-world', archived: false, auth: true, viewed: -1}, # No (hello)
      {user: bob, language: 'go', slug: 'anagram', archived: false, auth: true, viewed: -1, iteration_count: 0}, # No (zero iterations)
      {user: bob, language: 'haskell', slug: 'etl', archived: false, auth: false, viewed: +1}, # No (acl)... but it was viewed
    ].each do |exercise|
      ts = Time.now.utc
      auth = exercise.delete(:auth)
      viewed_diff_in_seconds = exercise.delete(:viewed)

      exercise[:iteration_count] ||= 1
      exercise = UserExercise.create(exercise.merge(last_activity_at: ts))
      if auth
        ACL.authorize(alice, exercise.problem)
      end

      View.create(user_id: alice.id, exercise_id: exercise.id, last_viewed_at: ts+viewed_diff_in_seconds)
    end

    # Intermediary steps - make it easier to debug.
    counts = UserTrack.exercise_counts_per_track(alice.id)
    assert_equal({"elixir" => 1, "go" => 4}, counts)

    counts = UserTrack.viewed_counts_per_track(alice.id)
    assert_equal({"go" => 3, "haskell" => 1}, counts)

    counts = UserTrack.problem_counts_in_track(alice.id, 'go')
    assert_equal({"hamming" => 1, "leap" => 1, "word-count" => 2}, counts)

    counts = UserTrack.viewed_counts_in_track(alice.id, 'go')
    assert_equal({"hamming" => 1, "leap" => 1, "word-count" => 1}, counts)

    # This is what we really care about
    tracks = UserTrack.all_for(alice)

    assert_equal 2, tracks.size

    t1, t2 = tracks

    assert_equal 'elixir', t1.id
    assert_equal 'Elixir', t1.name
    assert_equal 1, t1.total
    assert_equal 1, t1.unread

    assert_equal 'go', t2.id
    assert_equal 'Go', t2.name
    assert_equal 4, t2.total
    assert_equal 1, t2.unread

    problems = UserTrack.problems_for(alice, 'go')

    assert_equal 3, problems.size

    p1, p2, p3 = problems

    assert_equal 'Leap', p1.name
    assert_equal 1, p1.total
    assert_equal 0, p1.unread

    assert_equal 'Hamming', p2.name
    assert_equal 1, p2.total
    assert_equal 0, p2.unread

    assert_equal 'Word Count', p3.name
    assert_equal 2, p3.total
    assert_equal 1, p3.unread
  end
end
