require './test/test_helper'
require 'exercism/decaying_randomizer'
require 'mocha/setup'

class DecayingRandomizerTest < Minitest::Test

  def randomizer
    @randomizer ||= DecayingRandomizer.new(100)
  end

  def test_generates_values_less_than_upper_bound
    randomizer.stubs(:rand).returns(0.999)
    assert randomizer.next < 100, "Index greater than upper bound"
  end

  def test_generates_values_greater_than_zero
    randomizer.stubs(:rand).returns(0)
    assert randomizer.next >= 0,  "Index less than zero"
  end

  def test_approximates_normal_distribution
    # This is far from a brilliant test, but at least gives some
    # confidence that lower numbers are more likely to be chosen than
    # larger numbers.
    counts = 100.times.collect { 0 }
    1000.times do
      counts[randomizer.next] += 1
    end
    assert counts[0] > counts[50], "Middle of list more likely than start"
    assert counts[50] > counts[99], "End of list more likely than middle"
  end
end
