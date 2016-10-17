require_relative '../integration_helper'

class TrackStreamTest < Minitest::Test
  include DBCleaner

  def setup
    super
    slugs = ['anagram', 'clock', 'hamming', 'hello-world', 'leap', 'triangle', 'word-count']
    Stream.instance_variable_set(:"@ordered_slugs", 'go' => slugs, 'elixir' => slugs)
    Language.instance_variable_set(:"@by_track_id", {})
  end

  def teardown
    super
    Stream.instance_variable_set(:"@ordered_slugs", nil)
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  ExerciseTestCase = Struct.new(:user, :problem_name, :problem_track_id, :status, :comment_count) do
    def avatar_url
      user.avatar_url
    end

    def message
      [user.username, problem_track_id, problem_name].join(' ')
    end

    def unread?
      status == :unread
    end

    def username
      user.username
    end
  end

  # This tests the data for Alice's inbox.
  def test_inbox
    # Alice is a mentor in elixir, and is therefore authorized to see everything in that track.
    # In Go she can see only what she has submitted (Leap and Hamming, but not Clock).
    # Her own exercises appear in the inbox.
    # We won't bother with Bob's views and ACLs, since we're not testing his inbox.
    alice = User.create(username: 'alice', avatar_url: 'alice.jpg', track_mentor: ['elixir'])
    bob = User.create(username: 'bob', avatar_url: 'bob.jpg')

    [
      { user: alice, language: 'go', slug: 'word-count', archived: false, auth: true, viewed: +1 },
      { user: bob, language: 'elixir', slug: 'triangle', archived: false, auth: true, viewed: -1 },
      { user: bob, language: 'elixir', slug: 'anagram', archived: false, auth: true, viewed: -1 },
      { user: bob, language: 'elixir', slug: 'word-count', archived: false, auth: true, viewed: +1 },
      { user: bob, language: 'go', slug: 'hello-world', archived: false, auth: true, viewed: -1 },
      { user: bob, language: 'go', slug: 'leap', archived: false, auth: true, viewed: +1 },
      { user: bob, language: 'go', slug: 'clock', archived: false, auth: false, viewed: -1 },
      { user: bob, language: 'go', slug: 'word-count', archived: false, auth: true, viewed: -1 },
      { user: alice, language: 'go', slug: 'leap', archived: true, auth: true, viewed: +1 },
      { user: bob, language: 'go', slug: 'hamming', archived: true, auth: true, viewed: -1 },
      { user: bob, language: 'go', slug: 'anagram', archived: false, auth: true, viewed: -1, iteration_count: 0 },
      { user: alice, language: 'go', slug: 'hamming', archived: false, auth: true, viewed: +1 },
      { user: bob, language: 'go', slug: 'raindrops', archived: false, auth: true, viewed: 0 },
    ].each.with_index { |attributes, i| create_view alice, bob, attributes.merge(age: i) }

    elixir1 = TrackStream.new(alice, 'elixir')
    elixir1.per_page = 2
    elixir2 = TrackStream.new(alice, 'elixir', nil, 2)
    elixir2.per_page = 2
    go = TrackStream.new(alice, 'go')
    wc = TrackStream.new(alice, 'go', 'word-count')

    assert_equal 2, elixir1.exercises.size
    assert_equal 1, elixir2.exercises.size
    assert_equal 6, go.exercises.size
    assert_equal 2, wc.exercises.size

    # sanity check pagination
    assert_equal 3, elixir1.pagination_menu_item.total
    assert_equal 6, go.pagination_menu_item.total
    assert_equal 2, wc.pagination_menu_item.total

    ex1, ex2 = elixir1.exercises
    ex3 = elixir2.exercises.first
    ex4, ex5, ex6, ex7, ex8, ex11 = go.exercises
    ex9, ex10 = wc.exercises

    [
      [ex1,  ExerciseTestCase.new(bob, 'Triangle', 'elixir', :unread, 1)],
      [ex2,  ExerciseTestCase.new(bob, 'Anagram', 'elixir', :unread, 2)],
      [ex3,  ExerciseTestCase.new(bob, 'Word Count', 'elixir', :read, 3)],

      [ex4,  ExerciseTestCase.new(alice, 'Word Count', 'go', :read,  0)],
      [ex5,  ExerciseTestCase.new(bob, 'Hello World', 'go', :unread, 4)],
      [ex6,  ExerciseTestCase.new(bob, 'Leap', 'go', :read, 5)],
      [ex7,  ExerciseTestCase.new(bob, 'Word Count', 'go', :unread, 7)],
      [ex8,  ExerciseTestCase.new(alice, 'Hamming', 'go', :read, 11)],
      [ex11, ExerciseTestCase.new(bob, 'Raindrops', 'go', :unread, 12)],

      [ex9, ExerciseTestCase.new(alice, 'Word Count', 'go', :read,  0)],
      [ex10, ExerciseTestCase.new(bob, 'Word Count', 'go', :unread, 7)],
    ].each { |actual, expected| assert_exercise expected, actual }
  end

  def test_read_unread_status
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    mon, tue, wed, thu, fri = (4..8).map {|day| DateTime.new(2016, 1, day)}

    # Alice has submitted three exercises, and Bob is authorized to see them all.
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

      ACL.authorize(bob, exercise.problem)

      exercise
    end

    # Bob viewed hello-world.
    View.create(user_id: bob.id, exercise_id: hello.id, last_viewed_at: tue)

    # He also has a watermark on 'leap' in Go set to Thursday.
    Watermark.create!(user_id: bob.id, track_id: 'go', slug: 'leap', at: thu)

    go = TrackStream.new(bob, 'go')
    assert_equal 3, go.exercises.size
    clock, leap, hello = go.exercises
    refute hello.unread?, "hello-world should be viewed (explicitly)"
    refute leap.unread?, "leap should be viewed (because of the watermark)"
    assert clock.unread?, "clock should be unread"
  end

  def test_mark_as_read
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    exercises = []
    [
      { user: alice, language: 'python', slug: 'leap', auth: true },
      { user: bob, language: 'python', slug: 'leap', auth: true },
      { user: bob, language: 'python', slug: 'hamming', auth: true },
      { user: bob, language: 'python', slug: 'clock', auth: true },
      { user: bob, language: 'python', slug: 'word-count', auth: false}, # No ACL - still unread afterwards
      { user: bob, language: 'go', slug: 'leap', auth: true }, # not in stream - no watermark created
    ].each do |attributes|
      auth = attributes.delete(:auth)

      exercise = UserExercise.create(attributes)
      ACL.authorize(alice, exercise.problem) if auth

      exercises << exercise
    end

    # add an auth for bob—no watermark should be created for him
    ACL.authorize(bob, exercises.last.problem)
    # add an old watermark for alice
    before = Time.now - 1.day
    Watermark.create!(user_id: alice.id, track_id: 'python', slug: 'hamming', at: before)

    leap = TrackStream.new(alice, 'python', 'leap')

    now = Time.now.utc
    leap.mark_as_read

    # creates a watermark
    assert_equal 2, Watermark.count
    mark1, mark2 = Watermark.order('at ASC')

    assert_equal 'python', mark1.track_id
    assert_equal 'hamming', mark1.slug
    assert_in_delta 1, mark1.at.to_i, before.to_i

    assert_equal 'python', mark2.track_id
    assert_equal 'leap', mark2.slug
    assert_in_delta 1, mark2.at.to_i, now.to_i

    python = TrackStream.new(alice, 'python')
    now = Time.now.utc
    python.mark_as_read

    # creates one more watermark
    assert_equal 3, Watermark.count

    # updates all of them
    marks = Watermark.where(user_id: alice.id)
    marks.map(&:at).each do |ts|
      assert_in_delta 1, ts.to_i, now.to_i
    end
    expected = [
      "python:clock",
      "python:hamming",
      "python:leap",
    ]
    actual = marks.map { |mark| Problem.new(mark.track_id, mark.slug).id }.sort
    assert_equal expected, actual
  end

  def test_pagination_menu_item
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    [
      { user: alice, language: 'go', slug: 'leap', iteration_count: 1 },
      { user: bob, language: 'go', slug: 'leap', iteration_count: 1 },
      { user: bob, language: 'go', slug: 'hamming', iteration_count: 1 },
      { user: bob, language: 'go', slug: 'clock', iteration_count: 1 },
    ].each do |attributes|
      exercise = UserExercise.create!(attributes)
      ACL.authorize(alice, exercise.problem)
    end

    by_track = TrackStream.new(alice, 'go').pagination_menu_item
    assert_equal 'go', by_track.id
    assert_equal 4, by_track.total

    by_problem = TrackStream.new(alice, 'go', 'leap').pagination_menu_item
    assert_equal 'leap', by_problem.id
    assert_equal 2, by_problem.total

    mine = TrackStream.new(alice, 'go', nil, nil, true).pagination_menu_item
    assert_equal 'alice', mine.id
    assert_equal 1, mine.total
  end

  private

  def assert_exercise(expected, actual)
    message = expected.message
    assert_equal expected.username, actual.username, message
    assert_equal expected.avatar_url, actual.avatar_url, message
    assert_equal expected.problem_name, actual.problem.name, message
    assert_equal expected.problem_track_id, actual.problem.track_id, message
    assert_equal expected.comment_count, actual.comment_count, message
    assert_equal expected.unread?, actual.unread?, message
  end

  def create_view(user, other_user, message)
    comment_count = age = message.delete(:age)
    ts = age.days.ago
    auth = message.delete(:auth)
    viewed_diff_in_seconds = message.delete(:viewed)

    message[:iteration_count] ||= 1
    exercise = UserExercise.create!(message.merge(last_activity_at: ts))

    submission = Submission.create!(user_id: exercise.user_id, user_exercise_id: exercise.id, language: exercise.language, slug: exercise.slug)
    comment_count.times do
      # it doesn't matter who comments, we're going to count it anyway
      Comment.create!(submission_id: submission.id, user_id: [user.id, other_user.id].sample, body: "OHAI")
    end

    ACL.authorize(user, exercise.problem) if auth

    if viewed_diff_in_seconds != 0
      View.create(user_id: user.id, exercise_id: exercise.id, last_viewed_at: ts + viewed_diff_in_seconds)
    end
  end
end
