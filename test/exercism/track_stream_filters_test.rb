require_relative '../integration_helper'

class TeamStreamTest < Minitest::Test
  include DBCleaner

  def setup
    super
    Language.instance_variable_set(
      :"@by_track_id",
      "go" => "Go",
      "elixir" => "Elixir",
      "rust" => "Rust"
    )
    Stream.instance_variable_set(:"@ordered_slugs", "go" => %w(clock anagram triangle))
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

    create_exercise(alice, 'go', 'clock', alice.id)
    create_exercise(bob, 'go', 'clock', alice.id)
    create_exercise(bob, 'go', 'anagram')
    create_exercise(charlie, 'go', 'clock')
    create_exercise(charlie, 'go', 'triangle')

    create_exercise(bob, 'elixir', 'triangle', alice.id) # viewed (directly) without ACL
    create_exercise(charlie, 'elixir', 'bob')
    create_exercise(charlie, 'elixir', 'leap')

    create_exercise(charlie, 'rust', 'leap')

    [
      Problem.new('go', 'clock'),
      Problem.new('go', 'anagram'),
      Problem.new('go', 'triangle'),
      Problem.new('elixir', 'leap'),
      Problem.new('elixir', 'bob'),
    ].each do |problem|
      ACL.authorize(alice, problem)
    end

    filter = TrackStream::TrackFilter.new(alice.id, 'go')
    assert_equal 2, filter.items.size

    item1, item2 = filter.items

    assert_equal 'Elixir', item1.text
    assert_equal '/tracks/elixir/exercises', item1.url
    assert_equal 2, item1.total
    assert_equal 2, item1.unread
    refute item1.active?

    assert_equal 'Go', item2.text
    assert_equal '/tracks/go/exercises', item2.url
    assert_equal 5, item2.total
    assert_equal 3, item2.unread
    assert item2.active?

    filter = TrackStream::ProblemFilter.new(alice.id, 'go', 'clock')
    assert_equal 3, filter.items.size

    item1, item2, item3 = filter.items

    assert_equal 'Clock', item1.text
    assert_equal '/tracks/go/exercises/clock', item1.url
    assert_equal 3, item1.total
    assert_equal 1, item1.unread
    assert item1.active?

    assert_equal 'Anagram', item2.text
    assert_equal '/tracks/go/exercises/anagram', item2.url
    assert_equal 1, item2.total
    assert_equal 1, item2.unread
    refute item2.active?

    assert_equal 'Triangle', item3.text
    assert_equal '/tracks/go/exercises/triangle', item3.url
    assert_equal 1, item3.total
    assert_equal 1, item3.unread
    refute item3.active?

    filter = TrackStream::ViewerFilter.new(bob.id, 'go', true)
    assert_equal 1, filter.items.size


    item = filter.items.first


    assert_equal 'My Solutions', item.text
    assert_equal '/tracks/go/my_solutions', item.url
    assert_equal 2, item.total
    assert item.active?
  end

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
