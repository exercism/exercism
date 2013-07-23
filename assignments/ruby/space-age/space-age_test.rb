require 'minitest/autorun'
require_relative 'space_age'

class SpaceAgeTest < MiniTest::Unit::TestCase

  def test_age_in_seconds
    age = SpaceAge.new(1_000_000)
    assert_equal 1_000_000, age.seconds
  end

  def test_age_in_earth_years
    age = SpaceAge.new(1_000_000_000)
    assert_equal 31.69, age.on_earth
  end

  def test_age_in_mercury_years
    age = SpaceAge.new(2_134_835_688)
    assert_equal 67.65, age.on_earth
    assert_equal 280.88, age.on_mercury
  end

  def test_age_in_venus_years
    age = SpaceAge.new(189_839_836)
    assert_equal 6.02, age.on_earth
    assert_equal 9.78, age.on_venus
  end

  def test_age_on_mars
    age = SpaceAge.new(2_329_871_239)
    assert_equal 73.83, age.on_earth
    assert_equal 39.25, age.on_mars
  end

  def test_age_on_jupiter
    age = SpaceAge.new(901_876_382)
    assert_equal 28.58, age.on_earth
    assert_equal 2.41, age.on_jupiter
  end

  def test_age_on_saturn
    age = SpaceAge.new(3_000_000_000)
    assert_equal 95.06, age.on_earth
    assert_equal 3.23, age.on_saturn
  end

  def test_age_on_uranus
    age = SpaceAge.new(3_210_123_456)
    assert_equal 101.72, age.on_earth
    assert_equal 1.21, age.on_uranus
  end

  def test_age_on_neptune
    age = SpaceAge.new(8_210_123_456)
    assert_equal 260.16, age.on_earth
    assert_equal 1.58, age.on_neptune
  end

end
