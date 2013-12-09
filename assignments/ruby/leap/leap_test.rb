require 'minitest/autorun'
require_relative 'year'

class YearTest < MiniTest::Unit::TestCase
  def test_vanilla_leap_year
    assert Year.leap? 1996
  end

  def test_any_old_year
    skip
    refute Year.leap? 1997
  end

  def test_century
    skip
    refute Year.leap? 1900
  end

  def test_exceptional_century
    skip
    assert Year.leap? 2400
  end

end

