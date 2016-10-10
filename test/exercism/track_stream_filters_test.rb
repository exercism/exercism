require_relative '../integration_helper'

class TrackStreamFiltersTest < Minitest::Test
  include DBCleaner

  def setup
    super
    Language.instance_variable_set(
      :"@by_track_id",
      "go" => "Go",
      "elixir" => "Elixir",
      "rust" => "Rust"
    )
    Stream.instance_variable_set(:"@ordered_slugs", "go" => %w(leap clock anagram triangle))
  end

  def teardown
    super
    Language.instance_variable_set(:"@by_track_id", nil)
    Stream.instance_variable_set(:"@ordered_slugs", nil)
  end

  def test_filters
    alice = User.create!(username: 'alice', avatar_url: 'alice.jpg')
    bob = User.create!(username: 'bob', avatar_url: 'bob.jpg')
    charlie = User.create!(username: 'charlie', avatar_url: 'charlie.jpg')
    nobody = nil

    mon, tue, wed, thu = (4..7).map {|day| DateTime.new(2016, 1, day)}

    # We will use Alice as the viewer for all the filters.
    #
    # We need to ensure that each filter counts only views
    # on tracks and problems that will show up in the sidebar.
    # In other words: exercises that Alice has access to via
    # the acls table.
    #
    # Note: it's common to view exercises that you don't have
    # access to via the ACL table, because people share links.
    # These views should not be counted.
    #
    # We also use watermarks to mark a bunch of exercises in the
    # same track/problem as 'read' with a single database row.
    #
    # To do this we want to make sure that for each filter we have:
    # - at least one exercise that is unread
    # - at least one acl exercise that has been viewed
    # - at least one non-acl exercise that has been viewed
    # - at least one exercise that is unread but under the watermark
    # - at least one exercise that has a view timestamp that is older
    #   than the last activity on the exercise, and which has a
    #   watermark that is newer.
    #
    # We also need to make sure that the counts are correct in
    # the non-active category.
    # - When Alice is looking at the Go track, then Elixir will be
    #   present (and have a count) but Rust should not show up.
    # - When Alice is looking at Clock in Go, then Leap and
    #   Anagram should show up, but Triangle should not.
    #
    # Also:
    # - at least one equivalent exercise that _someone else_ has viewed
    # - at least one exercise in an equivalent category that is viewed

    # Go
    create_exercise(alice, 'go', 'leap', alice.id, mon) # read (directly)
    create_exercise(alice, 'go', 'clock', bob.id, mon) # read (watermark)
    create_exercise(alice, 'go', 'anagram', nobody, mon) # unread
    create_exercise(alice, 'go', 'gigasecond', alice.id, tue, -10) # read (earlier, then watermark)

    create_exercise(bob, 'go', 'leap', nobody, mon) # unread
    create_exercise(bob, 'go', 'clock', alice.id, tue) # read (watermark)
    create_exercise(bob, 'go', 'anagram', bob.id, mon) # unread
    create_exercise(bob, 'go', 'triangle', nobody, mon) # NO ACL
    create_exercise(bob, 'go', 'gigasecond', alice.id, mon, -10) # read (earlier, then watermark)

    create_exercise(charlie, 'go', 'leap', nobody, mon) # unread
    create_exercise(charlie, 'go', 'clock', bob.id, thu) # unroad
    create_exercise(charlie, 'go', 'triangle', alice.id, mon) # viewed (directly) without ACL

    # Elixir
    create_exercise(charlie, 'elixir', 'leap', nobody, mon)
    create_exercise(charlie, 'elixir', 'clock', alice.id, wed)

    create_exercise(bob, 'elixir', 'triangle', alice.id, mon) # viewed (directly) without ACL

    # Rust
    create_exercise(charlie, 'rust', 'leap', nobody, mon)
    create_exercise(charlie, 'rust', 'clock', alice.id, mon) # viewed w/o ACL

    [
      Problem.new('go', 'leap'),
      Problem.new('go', 'clock'),
      Problem.new('go', 'anagram'),
      Problem.new('go', 'gigasecond'),
      Problem.new('elixir', 'leap'),
      Problem.new('elixir', 'clock'),
    ].each do |problem|
      ACL.authorize(alice, problem)
    end

    Watermark.create!(user_id: alice.id, track_id: 'go', slug: 'clock', at: wed)
    Watermark.create!(user_id: alice.id, track_id: 'go', slug: 'gigasecond', at: wed)

    filter = TrackStream::TrackFilter.new(alice.id, 'go')
    assert_equal 2, filter.items.size

    item1, item2 = filter.items

    assert_equal 'Elixir', item1.text
    assert_equal '/tracks/elixir/exercises', item1.url
    assert_equal 2, item1.total
    assert_equal 1, item1.unread
    refute item1.active?

    assert_equal 'Go', item2.text
    assert_equal '/tracks/go/exercises', item2.url
    assert_equal 10, item2.total
    assert_equal 5, item2.unread
    assert item2.active?

    filter = TrackStream::ProblemFilter.new(alice.id, 'go', 'clock')
    assert_equal 4, filter.items.size

    item1, item2, item3, item4 = filter.items

    assert_equal 'Leap', item1.text
    assert_equal '/tracks/go/exercises/leap', item1.url
    assert_equal 3, item1.total
    assert_equal 2, item1.unread
    refute item1.active?, "leap should not be active"

    assert_equal 'Clock', item2.text
    assert_equal '/tracks/go/exercises/clock', item2.url
    assert_equal 3, item2.total
    assert_equal 1, item2.unread
    assert item2.active?, "clock should be active"

    assert_equal 'Anagram', item3.text
    assert_equal '/tracks/go/exercises/anagram', item3.url
    assert_equal 2, item3.total
    assert_equal 2, item3.unread
    refute item3.active?, "anagram should not be active"

    assert_equal 'Gigasecond', item4.text
    assert_equal '/tracks/go/exercises/gigasecond', item4.url
    assert_equal 2, item4.total
    assert_equal 0, item4.unread
    refute item4.active?, "gigasecond should not be active"

    only_mine = true
    filter = TrackStream::ViewerFilter.new(alice.id, 'go', only_mine)
    assert_equal 1, filter.items.size

    item = filter.items.first

    assert_equal 'My Solutions', item.text
    assert_equal '/tracks/go/my_solutions', item.url
    assert_equal 4, item.total
    assert_equal 1, item.unread
    assert item.active?
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
