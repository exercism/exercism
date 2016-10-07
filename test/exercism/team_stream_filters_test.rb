require_relative '../integration_helper'

class TeamStreamFiltersTest < Minitest::Test
  include DBCleaner

  def setup
    super
    Language.instance_variable_set(:"@by_track_id", "go" => "Go", "elixir" => "Elixir")
    Stream.instance_variable_set(:"@ordered_slugs", "go" => %w(leap clock anagram gigasecond))
  end

  def teardown
    super
    Language.instance_variable_set(:"@by_track_id", nil)
    Stream.instance_variable_set(:"@ordered_slugs", nil)
  end

  def test_filters
    alice = User.create!(username: 'alice')
    bob = User.create!(username: 'bob')
    charlie = User.create!(username: 'charlie')
    nobody = nil

    mon, tue, wed, thu = (4..7).map {|day| DateTime.new(2016, 1, day)}

    # Go
    create_exercise(alice, 'go', 'leap', nobody, mon)
    create_exercise(alice, 'go', 'clock', alice.id, mon)
    create_exercise(alice, 'go', 'gigasecond', alice.id, mon, -10)

    create_exercise(bob, 'go', 'leap', nobody, mon)
    create_exercise(bob, 'go', 'clock', bob.id, tue)
    create_exercise(bob, 'go', 'anagram', alice.id, mon)
    create_exercise(bob, 'go', 'gigasecond', alice.id, mon, -10)

    create_exercise(charlie, 'go', 'leap', nobody, mon)
    create_exercise(charlie, 'go', 'clock', nobody, thu)

    # Elixir
    create_exercise(bob, 'elixir', 'leap', nobody, mon)
    create_exercise(charlie, 'elixir', 'clock', alice.id, mon)

    user_ids = [alice.id, bob.id, charlie.id]

    Watermark.create!(user_id: alice.id, track_id: 'go', slug: 'clock', at: wed)
    Watermark.create!(user_id: alice.id, track_id: 'go', slug: 'gigasecond', at: wed)

    # Team filters ignore ACLs.

    # Team filter
    # This should include the count of everything in the track.
    filter = TeamStream::TeamFilter.new(alice.id, user_ids, 'teamster')
    assert_equal 1, filter.items.size

    item = filter.items.first

    assert_equal 'All', item.text
    assert_equal '/teams/teamster/streams', item.url
    assert_equal 11, item.total
    assert_equal 5, item.unread

    # Track filter, no track currently selected.
    filter = TeamStream::TrackFilter.new(alice.id, user_ids, 'teamster', nil)
    assert_equal 2, filter.items.size

    item1, item2 = filter.items

    assert_equal 'Elixir', item1.text
    assert_equal '/teams/teamster/streams/tracks/elixir', item1.url
    assert_equal 2, item1.total
    assert_equal 1, item1.unread
    refute item1.active?

    assert_equal 'Go', item2.text
    assert_equal '/teams/teamster/streams/tracks/go', item2.url
    assert_equal 9, item2.total
    assert_equal 4, item2.unread
    refute item2.active?

    # Track filter, Elixir selected.
    filter = TeamStream::TrackFilter.new(alice.id, user_ids, 'teamster', 'elixir')
    assert_equal 2, filter.items.size

    item1, item2 = filter.items
    assert_equal 'Elixir', item1.text
    assert item1.active?

    assert_equal 'Go', item2.text
    refute item2.active?

    # Problems in Go, none currently selected.
    filter = TeamStream::ProblemFilter.new(alice.id, user_ids, 'teamster', 'go', nil)
    assert_equal 4, filter.items.size

    item1, item2, item3 = filter.items

    assert_equal 'Leap', item1.text
    assert_equal '/teams/teamster/streams/tracks/go/exercises/leap', item1.url
    assert_equal 3, item1.total
    assert_equal 3, item1.unread
    refute item1.active?

    assert_equal 'Clock', item2.text
    assert_equal '/teams/teamster/streams/tracks/go/exercises/clock', item2.url
    assert_equal 3, item2.total
    assert_equal 1, item2.unread
    refute item2.active?

    assert_equal 'Anagram', item3.text
    assert_equal '/teams/teamster/streams/tracks/go/exercises/anagram', item3.url
    assert_equal 1, item3.total
    assert_equal 0, item3.unread
    refute item3.active?

    # Problems in Go, Anagram selected.
    filter = TeamStream::ProblemFilter.new(alice.id, user_ids, 'teamster', 'go', 'anagram')
    assert_equal 4, filter.items.size

    item1, item2, item3, item4 = filter.items

    assert_equal 'Leap', item1.text
    refute item1.active?

    assert_equal 'Clock', item2.text
    refute item2.active?

    assert_equal 'Anagram', item3.text
    assert item3.active?

    assert_equal 'Gigasecond', item4.text
    refute item4.active?

    # Users, none currently selected
    filter = TeamStream::UserFilter.new(alice.id, user_ids, 'teamster', nil)
    assert_equal 3, filter.items.size

    item1, item2, item3 = filter.items
    assert_equal 'alice', item1.text
    assert_equal '/teams/teamster/streams/users/alice', item1.url
    assert_equal 3, item1.total
    assert_equal 1, item1.unread
    refute item1.active?

    assert_equal 'bob', item2.text
    assert_equal '/teams/teamster/streams/users/bob', item2.url
    assert_equal 5, item2.total
    assert_equal 2, item2.unread
    refute item2.active?

    assert_equal 'charlie', item3.text
    assert_equal '/teams/teamster/streams/users/charlie', item3.url
    assert_equal 3, item3.total
    assert_equal 2, item3.unread
    refute item3.active?

    # Users, bob selected
    filter = TeamStream::UserFilter.new(alice.id, user_ids, 'teamster', 'bob')
    assert_equal 3, filter.items.size

    item1, item2, item3 = filter.items
    assert_equal 'alice', item1.text
    refute item1.active?

    assert_equal 'bob', item2.text
    assert item2.active?

    assert_equal 'charlie', item3.text
    refute item3.active?

    # Tracks for bob, no track selected
    filter = TeamStream::UserTrackFilter.new(alice.id, [bob.id], 'teamster', 'bob', nil)
    assert_equal 2, filter.items.size

    item1, item2 = filter.items

    assert_equal 'Elixir', item1.text
    assert_equal '/teams/teamster/streams/users/bob/tracks/elixir', item1.url
    assert_equal 1, item1.total
    assert_equal 1, item1.unread
    refute item1.active?

    assert_equal 'Go', item2.text
    assert_equal '/teams/teamster/streams/users/bob/tracks/go', item2.url
    assert_equal 4, item2.total
    assert_equal 1, item2.unread
    refute item2.active?

    # Tracks for bob, Go selected
    filter = TeamStream::UserTrackFilter.new(alice.id, [bob.id], 'teamster', 'bob', 'go')
    assert_equal 2, filter.items.size

    item1, item2 = filter.items

    assert_equal 'Elixir', item1.text
    refute item1.active?

    assert_equal 'Go', item2.text
    assert item2.active?
  end

  private

  def create_exercise(user, track_id, slug, viewed_by, timestamp, diff = 10)
    exercise = UserExercise.create!(user_id: user.id, language: track_id, slug: slug, iteration_count: 1, last_activity_at: timestamp)
    Submission.create!(user_id: user.id, user_exercise_id: exercise.id, language: track_id, slug: slug)
    unless viewed_by.nil?
      View.create(user_id: viewed_by, exercise_id: exercise.id, last_viewed_at: timestamp + diff)
    end
    exercise
  end
end
