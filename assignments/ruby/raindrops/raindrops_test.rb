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
    assert_equal "Pling", drops.convert(3)
  end

  def test_5
    assert_equal "Plang", drops.convert(5)
  end

  def test_7
    assert_equal "Plong", drops.convert(7)
  end

  def test_6
    assert_equal "Pling", drops.convert(6)
  end

  def test_9
    assert_equal "Pling", drops.convert(9)
  end

  def test_10
    assert_equal "Plang", drops.convert(10)
  end

  def test_14
    assert_equal "Plong", drops.convert(14)
  end

  def test_15
    assert_equal "PlingPlang", drops.convert(15)
  end

  def test_21
    assert_equal "PlingPlong", drops.convert(21)
  end

  def test_25
    assert_equal "Plang", drops.convert(25)
  end

  def test_35
    assert_equal "PlangPlong", drops.convert(35)
  end

  def test_49
    assert_equal "Plong", drops.convert(49)
  end

  def test_52
    assert_equal "52", drops.convert(52)
  end

  def test_105
    assert_equal "PlingPlangPlong", drops.convert(105)
  end

  def test_12121
    assert_equal "12121", drops.convert(12121)
  end

end
