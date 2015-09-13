require_relative '../integration_helper'
require 'mocha/setup'
require 'active_support/all'

class NitstatsTest < Minitest::Test
  include DBCleaner

  def user
    stub(id: 38)
  end

  def stats
    @stats ||= Nitstats.new(user)
  end

  def test_labels_for_each_day_of_last_30_days
    Date.stubs(:today).returns(Date.new(2013, 11, 30))
    Time.stubs(:now).returns(Time.utc(2013, 11, 30))

    expected = ["Nov 1", "Nov 2", "Nov 3", "Nov 4", "Nov 5", "Nov 6", "Nov 7", "Nov 8", "Nov 9", "Nov 10", "Nov 11", "Nov 12", "Nov 13", "Nov 14", "Nov 15", "Nov 16", "Nov 17", "Nov 18", "Nov 19", "Nov 20", "Nov 21", "Nov 22", "Nov 23", "Nov 24", "Nov 25", "Nov 26", "Nov 27", "Nov 28", "Nov 29", "Nov 30"]

    assert_equal expected, stats.data[:labels]
  end

  def test_nits_given_returned
    assert_equal 30, stats.data[:given].count
  end

  def test_nits_received_returned
    assert_equal 30, stats.data[:received].count
  end

  def test_steps_retured
    refute_nil stats.data[:steps]
  end

  def test_step_retured
    refute_nil stats.data[:step]
  end

  def test_correct_numbers_returned
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    sub1 = Submission.create(user: alice, language: 'python', slug: 'one')
    sub2 = Submission.create(user: bob, language: 'python', slug: 'two')
    Comment.create(user: alice, submission: sub1, body: 'something')
    Comment.create(user: alice, submission: sub2, body: 'something')
    Comment.create(user: bob, submission: sub2, body: 'something')

    assert_equal 0, Nitstats.new(alice).data[:received].last
    assert_equal 1, Nitstats.new(alice).data[:given].last
    assert_equal 0, Nitstats.new(bob).data[:given].last
    assert_equal 1, Nitstats.new(bob).data[:received].last
  end
end
