require 'minitest/autorun'
require_relative 'year'

class YearTest < MiniTest::Unit::TestCase
  def test_vanilla_leap_year
    assert Year.new(1996).leap?
  end

  def test_any_old_year
    skip
    assert !Year.new(1997).leap?
  end

  def test_century
    skip
    assert !Year.new(1900).leap?
  end

  def test_exceptional_century
    skip
    assert Year.new(2000).leap?
  end

  def test_leap_number
    skip
    assert 1996.leap_year?
  end

  def test_any_old_number
    skip
    assert !1997.leap_year?
  end

  def test_monkeypatched_century
    skip
    assert !1900.leap_year?
  end

  def test_exceptional_monkeypatched_century
    skip
    assert 2000.leap_year?
  end

end

require_relative './fixnum'
class FixnumTest < MiniTest::Unit::TestCase
  def test_vanilla_leap_year
    assert 1996.leap_year?
  end

  def test_any_old_year
    assert !1997.leap_year?
  end

  def test_century
    assert !1900.leap_year?
  end

  def test_exceptional_century
    assert 2000.leap_year?
  end

end
