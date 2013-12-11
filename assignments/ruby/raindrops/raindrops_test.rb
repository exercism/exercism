require 'minitest/autorun'
require_relative 'raindrops'

class RaindropsTest < MiniTest::Unit::TestCase

  def setup
    @drops = Raindrops.new
  end

  def drops
    @drops
  end

  def test_1
    assert_equal "1", drops.convert(1)
  end

  def test_3
    skip
    assert_equal "Pling", drops.convert(3)
  end

  def test_5
    skip
    assert_equal "Plang", drops.convert(5)
  end

  def test_7
    skip
    assert_equal "Plong", drops.convert(7)
  end

  def test_6
    skip
    assert_equal "Pling", drops.convert(6)
  end

  def test_9
    skip
    assert_equal "Pling", drops.convert(9)
  end

  def test_10
    skip
    assert_equal "Plang", drops.convert(10)
  end

  def test_14
    skip
    assert_equal "Plong", drops.convert(14)
  end

  def test_15
    skip
    assert_equal "PlingPlang", drops.convert(15)
  end

  def test_21
    skip
    assert_equal "PlingPlong", drops.convert(21)
  end

  def test_25
    skip
    assert_equal "Plang", drops.convert(25)
  end

  def test_35
    skip
    assert_equal "PlangPlong", drops.convert(35)
  end

  def test_49
    skip
    assert_equal "Plong", drops.convert(49)
  end

  def test_52
    skip
    assert_equal "52", drops.convert(52)
  end

  def test_105
    skip
    assert_equal "PlingPlangPlong", drops.convert(105)
  end

  def test_12121
    skip
    assert_equal "12121", drops.convert(12121)
  end

end
