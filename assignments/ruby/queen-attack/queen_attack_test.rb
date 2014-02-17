require 'minitest/autorun'
require_relative 'queens'

class QueensTest < MiniTest::Unit::TestCase

  def test_default_positions
    queens = Queens.new
    assert_equal [0, 3], queens.white
    assert_equal [7, 3], queens.black
  end

  def test_specific_placement
    skip
    queens = Queens.new(white: [3, 7], black: [6, 1])
    assert_equal [3, 7], queens.white
    assert_equal [6, 1], queens.black
  end

  def test_multiple_boards_simultaneously
    skip
    queens1 = Queens.new(white: [3, 7], black: [6, 1])
    queens2 = Queens.new(white: [5, 4], black: [7, 7])
    assert_equal [3, 7], queens1.white
    assert_equal [6, 1], queens1.black
    assert_equal [5, 4], queens2.white
    assert_equal [7, 7], queens2.black
  end

  def test_cannot_occupy_same_space
    skip
    assert_raises ArgumentError do
      Queens.new(white: [2, 4], black: [2, 4])
    end
  end

  def test_string_representation
    skip
    queens = Queens.new(white: [2, 4], black: [6, 6])
    board = <<-BOARD.chomp
O O O O O O O O
O O O O O O O O
O O O O W O O O
O O O O O O O O
O O O O O O O O
O O O O O O O O
O O O O O O B O
O O O O O O O O
    BOARD
    assert_equal board, queens.to_s
  end

  def test_another_string_representation
    skip
    queens = Queens.new(white: [7, 1], black: [0, 0])
    board = <<-BOARD.chomp
B O O O O O O O
O O O O O O O O
O O O O O O O O
O O O O O O O O
O O O O O O O O
O O O O O O O O
O O O O O O O O
O W O O O O O O
    BOARD
    assert_equal board, queens.to_s
  end

  def test_yet_another_string_representation
    skip
    queens = Queens.new(white: [4, 3], black: [3, 4])
    board = <<-BOARD.chomp
O O O O O O O O
O O O O O O O O
O O O O O O O O
O O O O B O O O
O O O W O O O O
O O O O O O O O
O O O O O O O O
O O O O O O O O
    BOARD
    assert_equal board, queens.to_s
  end

  def test_cannot_attack
    skip
    queens = Queens.new(white: [2, 3], black: [4, 7])
    assert !queens.attack?
  end

  def test_can_attack_on_same_row
    skip
    queens = Queens.new(white: [2, 4], black: [2, 7])
    assert queens.attack?
  end

  def test_can_attack_on_same_column
    skip
    queens = Queens.new(white: [5, 4], black: [2, 4])
    assert queens.attack?
  end

  def test_can_attack_on_diagonal
    skip
    queens = Queens.new(white: [1, 1], black: [6, 6])
    assert queens.attack?
  end

  def test_can_attack_on_other_diagonal
    skip
    queens = Queens.new(white: [0, 6], black: [1, 7])
    assert queens.attack?
  end

  def test_can_attack_on_yet_another_diagonal
    skip
    queens = Queens.new(white: [4, 1], black: [6, 3])
    assert queens.attack?
  end

  def test_can_attack_on_a_diagonal_slanted_the_other_way
    skip
    queens = Queens.new(white: [6, 1], black: [1, 6])
    assert queens.attack?
  end
end

