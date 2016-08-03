require_relative '../test_helper'
require 'exercism'

class StreamExerciseTest < Minitest::Test

  # Also not constructed :/
  def test_comment_count
    exercise = Stream::Exercise.new()

    expected = 0
    new_value = 5

    assert_equal expected, exercise.comment_count
    exercise.comment_count = new_value
    assert_equal new_value, exercise.comment_count

  end

  def test_at
    date = '2016-08-01'
    args = [:id, :uuid, :problem, :last_activity, date, :iteration_count, :last_activity_at, :help_requested, :avatar_url]
    exercise = Stream::Exercise.new(*args)
    expected = date.to_datetime
    assert_equal expected, exercise.at
  end

  # It's not possible to construct a viewed exercise.
  def test_viewed!
    # See test_unread?
  end

  # It's not possible to construct an viewed exercise.
  def test_unread?
    exercise = Stream::Exercise.new()
    assert exercise.unread?
    exercise.viewed!
    refute exercise.unread?
  end

  def test_help_requested_false?
    args = []
    exercise = Stream::Exercise.new(*args)
    refute exercise.help_requested?
  end

  def test_help_requested_true?
    args = [:id, :uuid, :problem, :last_activity, :last_activity_at, :iteration_count, :last_activity_at, :help_requested, :avatar_url]
    exercise = Stream::Exercise.new(*args)
    assert exercise.help_requested?, 'Help should be requested'
  end

end
