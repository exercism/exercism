require 'minitest/autorun'
require 'minitest/pride'
require_relative 'robot'

class RobotTest < MiniTest::Unit::TestCase

  def robot
    @robot
  end

  def setup
    @robot = Robot.new
  end

  def test_robot_bearing
    [:east, :west, :north, :south].each do |direction|
      robot.orient(direction)
      assert_equal direction, robot.bearing
    end
  end

  def test_invalid_robot_bearing
    skip
    assert_raises ArgumentError do
      robot.orient(:crood)
    end
  end

  def test_turn_right_from_north
    skip
    robot.orient(:north)
    robot.turn_right
    assert_equal :east, robot.bearing
  end

  def test_turn_right_from_east
    skip
    robot.orient(:east)
    robot.turn_right
    assert_equal :south, robot.bearing
  end

  def test_turn_right_from_south
    skip
    robot.orient(:south)
    robot.turn_right
    assert_equal :west, robot.bearing
  end

  def test_turn_right_from_west
    skip
    robot.orient(:west)
    robot.turn_right
    assert_equal :north, robot.bearing
  end

  def test_turn_left_from_north
    skip
    robot.orient(:north)
    robot.turn_left
    assert_equal :west, robot.bearing
  end

  def test_turn_left_from_east
    skip
    robot.orient(:east)
    robot.turn_left
    assert_equal :north, robot.bearing
  end

  def test_turn_left_from_south
    skip
    robot.orient(:south)
    robot.turn_left
    assert_equal :east, robot.bearing
  end

  def test_turn_left_from_west
    skip
    robot.orient(:west)
    robot.turn_left
    assert_equal :south, robot.bearing
  end

  def test_robot_coordinates
    skip
    robot.at(3, 0)
    assert_equal [3, 0], robot.coordinates
  end

  def test_other_robot_coordinates
    skip
    robot.at(-2, 5)
    assert_equal [-2, 5], robot.coordinates
  end

  def test_advance_when_facing_north
    skip
    robot.at(0,0)
    robot.orient(:north)
    robot.advance
    assert_equal [0, 1], robot.coordinates
  end

  def test_advance_when_facing_east
    skip
    robot.at(0,0)
    robot.orient(:east)
    robot.advance
    assert_equal [1, 0], robot.coordinates
  end

  def test_advance_when_facing_south
    skip
    robot.at(0,0)
    robot.orient(:south)
    robot.advance
    assert_equal [0, -1], robot.coordinates
  end

  def test_advance_when_facing_west
    skip
    robot.at(0,0)
    robot.orient(:west)
    robot.advance
    assert_equal [-1, 0], robot.coordinates
  end
end
