require 'minitest/autorun'
require_relative 'year'

class YearTest < MiniTest::Unit::TestCase
  def test_vanilla_leap_year
    assert Year.new(1996).leap?
  end

  def test_any_old_year
    skip
    refute Year.new(1997).leap?
  end

  def test_century
    skip
    refute Year.new(1900).leap?
  end

  def test_exceptional_century
    skip
    assert Year.new(2400).leap?
  end

end

