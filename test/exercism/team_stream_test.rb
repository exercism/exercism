require_relative '../integration_helper'

class TeamStreamTest < Minitest::Test
  include DBCleaner

  def setup
    super
    Stream.instance_variable_set(:"@ordered_slugs", 'go' => %w(clock anagram))
    Language.instance_variable_set(:"@by_track_id", "go" => "Go", "elixir" => "Elixir")
  end

  def teardown
    super
    Stream.instance_variable_set(:"@ordered_slugs", nil)
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  def test_stream
    alice = User.create!(username: 'alice', avatar_url: 'alice.jpg')
    bob = User.create!(username: 'bob', avatar_url: 'bob.jpg')

    team = Team.create!(slug: 'the-team', name: 'The Team')
    [alice, bob].each do |user|
      TeamMembership.create!(team_id: team.id, user_id: user.id, confirmed: true)
    end

    # Don't show stuff from unconfirmed members.
    charlie = User.create!(username: 'charlie', avatar_url: 'charlie.jpg')
    TeamMembership.create!(team_id: team.id, user_id: charlie.id, confirmed: false)

    ex1 = create_exercise(alice, 'go', 'clock', alice.id)
    ex2 = create_exercise(bob, 'go', 'clock', alice.id)
    ex3 = create_exercise(bob, 'go', 'anagram')
    ex4 = create_exercise(bob, 'elixir', 'triangle')
    ex5 = create_exercise(charlie, 'go', 'clock')

    # no filters
    stream = TeamStream.new(team, alice.id)
    assert_equal 4, stream.exercises.size
    refute stream.exercises.map(&:id).include?(ex5.id)
    assert_equal "The Team", stream.title
    assert_equal [ex3, ex4].map(&:id).sort, stream.exercises.select(&:unread?).map(&:id).sort

    # filter by go
    stream = TeamStream.new(team, alice.id)
    stream.track_id = 'go'
    assert_equal [ex1, ex2, ex3].map(&:id).sort, stream.exercises.map(&:id).sort
    assert_equal "Go", stream.title

    # filter by go/clock
    stream = TeamStream.new(team, alice.id)
    stream.track_id = 'go'
    stream.slug = 'clock'
    assert_equal [ex1, ex2].map(&:id).sort, stream.exercises.map(&:id).sort
    assert_equal "Go Clock", stream.title

    # filter by bob
    stream = TeamStream.new(team, alice.id)
    stream.user = bob
    assert_equal [ex2, ex3, ex4].map(&:id).sort, stream.exercises.map(&:id).sort
    assert_equal "bob", stream.title

    # filter by bob, go
    stream = TeamStream.new(team, alice.id)
    stream.user = bob
    stream.track_id = 'go'
    assert_equal [ex2, ex3].map(&:id).sort, stream.exercises.map(&:id).sort
    assert_equal "bob (Go)", stream.title

    # Test comment counts.
    s1 = Submission.create!(user_id: bob.id, user_exercise_id: ex2.id, language: ex2.language, slug: ex2.slug)
    s2 = Submission.create!(user_id: bob.id, user_exercise_id: ex2.id, language: ex2.language, slug: ex2.slug)
    Comment.create!(submission_id: s1.id, user_id: [alice.id, bob.id, charlie.id].sample, body: "OHAI")
    Comment.create!(submission_id: s1.id, user_id: [alice.id, bob.id, charlie.id].sample, body: "OHAI")
    Comment.create!(submission_id: s2.id, user_id: [alice.id, bob.id, charlie.id].sample, body: "OHAI")

    stream = TeamStream.new(team, alice.id)
    exercise = stream.exercises.find { |ex| ex.id == ex2.id }
    assert_equal 3, exercise.comment_count
  end

  def test_read_unread_status
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    team = Team.create!(slug: 'the-team', name: 'The Team')
    [alice, bob].each do |user|
      TeamMembership.create!(team_id: team.id, user_id: user.id, confirmed: true)
    end

    mon, tue, wed, thu, fri = (4..8).map {|day| DateTime.new(2016, 1, day)}

    # Alice has submitted three exercises.
    hello, leap, clock = {
      'hello-world' => mon, 'leap' => wed, 'clock' => fri
    }.map do |slug, ts|
      exercise = UserExercise.create!(user_id: alice.id, language: 'go', slug: slug, iteration_count: 1, last_activity_at: ts)

      attributes = {
        user_id: exercise.user_id,
        user_exercise_id: exercise.id,
        language: exercise.language,
        slug: exercise.slug,
        created_at: ts,
        updated_at: ts,
      }
      Submission.create!(attributes)

      exercise
    end

    # Bob viewed hello-world.
    View.create(user_id: bob.id, exercise_id: hello.id, last_viewed_at: tue)

    # He also has a watermark on 'leap' in Go set to Thursday.
    Watermark.create!(user_id: bob.id, track_id: 'go', slug: 'leap', at: thu)

    stream = TeamStream.new(team, bob.id)
    assert_equal 3, stream.exercises.size

    clock, leap, hello = stream.exercises
    refute hello.unread?, "hello-world should be viewed (explicitly)"
    refute leap.unread?, "leap should be viewed (because of the watermark)"
    assert clock.unread?, "clock should be unread"
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
