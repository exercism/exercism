require_relative '../integration_helper'
require 'exercism'

class ViewTest < Minitest::Test
  include DBCleaner

  def test_delete_below_watermark
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    mon, tue, wed, thu, fri = (4..8).map {|day| Time.new(2016, 1, day)}

    attributes = {
      language: 'go',
      slug: 'hamming',
      archived: false,
      last_activity_at: fri,
    }

    [mon, tue, wed, thu, fri].each do |timestamp|
      exercise = UserExercise.create(attributes.merge(user_id: timestamp.day)) # random, non-existent user
      View.create(user_id: alice.id, exercise_id: exercise.id, last_viewed_at: timestamp)
    end
    View.create(user_id: bob.id, exercise_id: UserExercise.first.id, last_viewed_at: mon)

    Watermark.create(user_id: alice.id, track_id: 'go', slug: 'hamming', at: thu)

    assert_equal 6, View.count

    # This should remove mon, tue, wed, and thu for Alice, but nothing for bob.
    View.delete_below_watermarks

    assert_equal 2, View.count
  end
end
