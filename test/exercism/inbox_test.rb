require_relative '../integration_helper'

# override the slug order so it doesn't look it up from the x-api
class UserTrack
  def self.ordered_slugs(_)
    [ 'anagram', 'clock', 'hamming', 'hello-world', 'leap', 'triangle', 'word-count' ]
  end
end

class InboxTrackTest < Minitest::Test
  include DBCleaner

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
      {user: alice, language: 'go', slug: 'word-count', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'elixir', slug: 'triangle', archived: false, auth: true, viewed: -1},
      {user: bob, language: 'elixir', slug: 'anagram', archived: false, auth: true, viewed: -1},
      {user: bob, language: 'elixir', slug: 'word-count', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'hello-world', archived: false, auth: true, viewed: -1},
      {user: bob, language: 'go', slug: 'leap', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'clock', archived: false, auth: false, viewed: -1},
      {user: bob, language: 'go', slug: 'word-count', archived: false, auth: true, viewed: -1},
      {user: alice, language: 'go', slug: 'leap', archived: true, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'hamming', archived: true, auth: true, viewed: -1},
      {user: bob, language: 'go', slug: 'anagram', archived: false, auth: true, viewed: -1, iteration_count: 0},
      {user: alice, language: 'go', slug: 'hamming', archived: false, auth: true, viewed: +1},
      {user: bob, language: 'go', slug: 'raindrops', archived: false, auth: true, viewed: 0},
    ].each.with_index { |attributes, i| create_view alice, bob, attributes.merge(age: i) }

    elixir1 = Inbox.new(alice, 'elixir')
    elixir1.per_page = 2
    elixir2 = Inbox.new(alice, 'elixir', nil, 2)
    elixir2.per_page = 2
    go = Inbox.new(alice, 'go')
    wc = Inbox.new(alice, 'go', 'word-count')

    assert_equal 2, elixir1.exercises.size
    assert_equal 1, elixir2.exercises.size
    assert_equal 5, go.exercises.size
    assert_equal 2, wc.exercises.size

    # sanity check pagination
    assert_equal 3, elixir1.current.total
    assert_equal 5, go.current.total
    assert_equal 2, wc.current.total

    ex1, ex2 = elixir1.exercises
    ex3 = elixir2.exercises.first
    ex4, ex5, ex6, ex7, ex8 = go.exercises
    ex9, ex10 = wc.exercises

    [
      [ex1,  ExerciseTestCase.new(bob  , 'Triangle'  , 'elixir', :unread,  1)],
      [ex2,  ExerciseTestCase.new(bob  , 'Anagram'   , 'elixir', :unread,  2)],
      [ex3,  ExerciseTestCase.new(bob  , 'Word Count', 'elixir', :read  ,  3)],
      [ex4,  ExerciseTestCase.new(alice, 'Word Count', 'go'    , :read  ,  0)],
      [ex5,  ExerciseTestCase.new(bob  , 'Leap'      , 'go'    , :read  ,  5)],
      [ex6,  ExerciseTestCase.new(bob  , 'Word Count', 'go'    , :unread,  7)],
      [ex7,  ExerciseTestCase.new(alice, 'Hamming'   , 'go'    , :read  , 11)],
      [ex8,  ExerciseTestCase.new(bob  , 'Raindrops' , 'go'    , :unread, 12)],
      [ex9,  ExerciseTestCase.new(alice, 'Word Count', 'go'    , :read  ,  0)],
      [ex10,  ExerciseTestCase.new(bob  , 'Word Count', 'go'    , :unread,  7)],
    ].each { |actual, expected| assert_exercise expected, actual }

    # most recent unread
    assert_equal ex6.uuid, go.first_unread_uuid
    assert_equal ex6.uuid, wc.first_unread_uuid
    assert_equal nil, Inbox.new(alice, 'go', 'clock').first_unread_uuid # not authorized
    assert_equal ex8.uuid, Inbox.new(alice, 'go', 'raindrops').first_unread_uuid # no view record

    # last exercise
    assert_equal ex8.id, go.last_id
    assert_equal ex10.id, wc.last_id
    assert_equal 0, Inbox.new(alice, 'rust').last_id
  end

  def test_mark_as_read
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    charlie = User.create(username: 'charlie')

    exercises = []

    yesterday = 1.day.ago
    [
      {user: alice, language: 'python', slug: 'leap', auth: true, viewed: false},
      {user: bob, language: 'python', slug: 'leap', auth: true, viewed: false},
      {user: charlie, language: 'python', slug: 'leap', auth: true, viewed: false},
      {user: bob, language: 'python', slug: 'hamming', auth: true, viewed: true}, # timestamp gets updated
      {user: bob, language: 'python', slug: 'anagram', auth: true, viewed: false},
      {user: bob, language: 'go', slug: 'clock', auth: true, viewed: false}, # still unread afterwards
      {user: bob, language: 'go', slug: 'hamming', auth: true, viewed: true}, # does not update timestamp
      {user: bob, language: 'python', slug: 'word-count', auth: false, viewed: false}, # No ACL - still unread afterwards
    ].each do |attributes|
      auth = attributes.delete(:auth)
      viewed = attributes.delete(:viewed)

      exercise = UserExercise.create(attributes)
      if auth
        ACL.authorize(alice, exercise.problem)
      end

      if viewed
        View.create(user_id: alice.id, exercise_id: exercise.id, last_viewed_at: yesterday)
      end

      exercises << exercise
    end

    # add a random view for bob, that should not get updated
    View.create(user_id: bob.id, exercise_id: exercises[0].id, last_viewed_at: yesterday)
    # add an auth for bob
    ACL.authorize(bob, exercises.last.problem)

    assert_equal 3, View.count

    leap = Inbox.new(alice, 'python', 'leap')
    python = Inbox.new(alice, 'python')

    now = Time.now.utc
    leap.mark_as_read

    assert_equal 6, View.count

    views = View.where('last_viewed_at > ?', now-2)
    assert_equal 3, views.size

    assert_equal exercises[0...3].map(&:id).sort, views.map(&:exercise_id).sort

    views.each do |view|
      assert_equal alice.id, view.user_id
      assert_in_delta 1, view.last_viewed_at.to_i, now.to_i
    end

    now = Time.now.utc
    python.mark_as_read

    assert_equal 7, View.count

    views = View.where('last_viewed_at > ?', now-2)
    assert_equal 5, views.size
    assert_equal exercises[0...5].map(&:id).sort, views.map(&:exercise_id).sort
    views.each do |view|
      assert_equal alice.id, view.user_id
      assert_in_delta 1, view.last_viewed_at.to_i, now.to_i
    end
  end

  private

  def assert_exercise expected, actual
    message = expected.message
    assert_equal expected.username        , actual.username        , message
    assert_equal expected.avatar_url      , actual.avatar_url      , message
    assert_equal expected.problem_name    , actual.problem.name    , message
    assert_equal expected.problem_track_id, actual.problem.track_id, message
    assert_equal expected.comment_count   , actual.comment_count   , message
    assert_equal expected.unread?         , actual.unread?         , message
  end

  def create_view user, other_user, message
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

    if auth
      ACL.authorize(user, exercise.problem)
    end

    if viewed_diff_in_seconds != 0
      View.create(user_id: user.id, exercise_id: exercise.id, last_viewed_at: ts+viewed_diff_in_seconds)
    end
  end
end
