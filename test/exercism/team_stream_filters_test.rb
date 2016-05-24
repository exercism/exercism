require_relative '../integration_helper'

class TeamStreamTest < Minitest::Test
  include DBCleaner

  def setup
    super
    Language.instance_variable_set(:"@by_track_id", "go" => "Go", "elixir" => "Elixir")
    TeamStream.instance_variable_set(:"@ordered_slugs", "go" => %w(clock anagram))
  end

  def teardown
    super
    Language.instance_variable_set(:"@by_track_id", nil)
    TeamStream.instance_variable_set(:"@ordered_slugs", nil)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def test_filters
    alice = User.create!(username: 'alice', avatar_url: 'alice.jpg')
    bob = User.create!(username: 'bob', avatar_url: 'bob.jpg')
    charlie = User.create!(username: 'charlie', avatar_url: 'charlie.jpg')

    create_exercise(alice, 'go', 'clock', alice.id)
    create_exercise(bob, 'go', 'clock', alice.id)
    create_exercise(bob, 'go', 'anagram')
    create_exercise(bob, 'elixir', 'triangle')
    create_exercise(charlie, 'go', 'clock')

    user_ids = [alice.id, bob.id, charlie.id]

    # Team filter
    filter = TeamStream::TeamFilter.new(alice.id, user_ids, 'teamster')
    assert_equal 1, filter.items.size

    item = filter.items.first

    assert_equal 'All', item.text
    assert_equal '/teams/teamster/streams', item.url
    assert_equal 5, item.total
    assert_equal 3, item.unread

    # Track filter, no track currently selected.
    filter = TeamStream::TrackFilter.new(alice.id, user_ids, 'teamster', nil)
    assert_equal 2, filter.items.size

    item1, item2 = filter.items

    assert_equal 'Elixir', item1.text
    assert_equal '/teams/teamster/streams/tracks/elixir', item1.url
    assert_equal 1, item1.total
    assert_equal 1, item1.unread
    refute item1.active?

    assert_equal 'Go', item2.text
    assert_equal '/teams/teamster/streams/tracks/go', item2.url
    assert_equal 4, item2.total
    assert_equal 2, item2.unread
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
    assert_equal 2, filter.items.size

    item1, item2 = filter.items

    assert_equal 'Clock', item1.text
    assert_equal '/teams/teamster/streams/tracks/go/exercises/clock', item1.url
    assert_equal 3, item1.total
    assert_equal 1, item1.unread
    refute item1.active?

    assert_equal 'Anagram', item2.text
    assert_equal '/teams/teamster/streams/tracks/go/exercises/anagram', item2.url
    assert_equal 1, item2.total
    assert_equal 1, item1.unread
    refute item2.active?

    # Problems in Go, Anagram selected.
    filter = TeamStream::ProblemFilter.new(alice.id, user_ids, 'teamster', 'go', 'anagram')
    assert_equal 2, filter.items.size

    item1, item2 = filter.items
    assert_equal 'Clock', item1.text
    refute item1.active?

    assert_equal 'Anagram', item2.text
    assert item2.active?

    # Users, none currently selected
    filter = TeamStream::UserFilter.new(alice.id, user_ids, 'teamster', nil)
    assert_equal 3, filter.items.size

    item1, item2, item3 = filter.items
    assert_equal 'alice', item1.text
    assert_equal '/teams/teamster/streams/users/alice', item1.url
    assert_equal 1, item1.total
    assert_equal 0, item1.unread
    refute item1.active?

    assert_equal 'bob', item2.text
    assert_equal '/teams/teamster/streams/users/bob', item2.url
    assert_equal 3, item2.total
    assert_equal 2, item2.unread
    refute item2.active?

    assert_equal 'charlie', item3.text
    assert_equal '/teams/teamster/streams/users/charlie', item3.url
    assert_equal 1, item3.total
    assert_equal 1, item3.unread
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
    assert_equal 2, item2.total
    assert_equal 1, item2.unread
    refute item2.active?

    # Tracks for charlie, no track selected
    filter = TeamStream::UserTrackFilter.new(alice.id, [charlie.id], 'teamster', 'charlie', nil)
    assert_equal 1, filter.items.size

    item = filter.items.first

    assert_equal 'Go', item.text
    assert_equal '/teams/teamster/streams/users/charlie/tracks/go', item.url
    assert_equal 1, item.total
    assert_equal 1, item.unread
    refute item.active?

    # Tracks for charlie, Go selected
    filter = TeamStream::UserTrackFilter.new(alice.id, [charlie.id], 'teamster', 'charlie', 'go')
    assert_equal 1, filter.items.size

    item = filter.items.first

    assert_equal 'Go', item.text
    assert item.active?
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def create_exercise(user, track_id, slug, viewed_by=nil)
    now = Time.now
    exercise = UserExercise.create!(user_id: user.id, language: track_id, slug: slug, iteration_count: 1, last_activity_at: now - 10)
    Submission.create!(user_id: user.id, user_exercise_id: exercise.id, language: track_id, slug: slug)
    unless viewed_by.nil?
      View.create(user_id: viewed_by, exercise_id: exercise.id, last_viewed_at: now + 10)
    end
    exercise
  end
end
