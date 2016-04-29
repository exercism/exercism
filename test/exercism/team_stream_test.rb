require_relative '../integration_helper'

class TeamStreamTest < Minitest::Test
  include DBCleaner

  def setup
    super
    Stream.instance_variable_set(:"@ordered_slugs", {'go' => ['clock', 'anagram']})
    Language.instance_variable_set(:"@by_track_id", {"go" => "Go", "elixir" => "Elixir"})
  end

  def teardown
    super
    Stream.instance_variable_set(:"@ordered_slugs", nil)
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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
    exercise = stream.exercises.select {|ex| ex.id == ex2.id}.first
    assert_equal 3, exercise.comment_count
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
