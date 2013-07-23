require 'minitest/autorun'
require_relative 'roman'

class RomanTest < MiniTest::Unit::TestCase

  def test_1
    assert_equal 'I', 1.to_roman
  end

  def test_2
    skip
    assert_equal 'II', 2.to_roman
  end

  def test_3
    skip
    assert_equal 'III', 3.to_roman
  end

  def test_4
    skip
    assert_equal 'IV', 4.to_roman
  end

  def test_5
    skip
    assert_equal 'V', 5.to_roman
  end

  def test_6
    skip
    assert_equal 'VI', 6.to_roman
  end

  def test_9
    skip
    assert_equal 'IX', 9.to_roman
  end


  def test_27
    skip
    assert_equal 'XXVII', 27.to_roman
  end

  def test_48
    skip
    assert_equal 'XLVIII', 48.to_roman
  end

  def test_59
    skip
    assert_equal 'LIX', 59.to_roman
  end

  def test_93
    skip
    assert_equal 'XCIII', 93.to_roman
  end

  def test_141
    skip
    assert_equal 'CXLI', 141.to_roman
  end

  def test_163
    skip
    assert_equal 'CLXIII', 163.to_roman
  end

  def test_402
    skip
    assert_equal 'CDII', 402.to_roman
  end

  def test_575
    skip
    assert_equal 'DLXXV', 575.to_roman
  end

  def test_911
    skip
    assert_equal 'CMXI', 911.to_roman
  end

  def test_1024
    skip
    assert_equal 'MXXIV', 1024.to_roman
  end

  def test_3000
    skip
    assert_equal 'MMM', 3000.to_roman
  end

end
