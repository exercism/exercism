require './test/integration_helper'
require 'mocha/setup'
require 'active_support/all'

class NitstatsTest < Minitest::Test

  def user
    stub(id: 38)
  end

  def stats
    @stats ||= Nitstats.new(user)
  end

  def test_labels_for_each_day_of_last_30_days
    Date.stubs(:today).returns(Date.new(2013, 11, 30))
    Time.stubs(:now).returns(Time.new(2013, 11, 30))

    assert_equal ["01/11", "02/11", "03/11", "04/11", "05/11", "06/11", "07/11", "08/11", "09/11", "10/11", "11/11", "12/11", "13/11", "14/11", "15/11", "16/11", "17/11", "18/11", "19/11", "20/11", "21/11", "22/11", "23/11", "24/11", "25/11", "26/11", "27/11", "28/11", "29/11", "30/11"],
      stats.data[:labels]
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
end
