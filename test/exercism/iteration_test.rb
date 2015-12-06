require_relative '../test_helper'
require 'exercism/iteration'
require 'exercism/code'

class IterationTest < Minitest::Test
  def test_single_file
    solution = {
      'ruby/one/file.rb' => 'puts "ok"',
    }
    iteration = Iteration.new(solution)
    assert_equal 'ruby', iteration.track_id
    assert_equal 'one', iteration.slug

    expected_solution = {
      'file.rb' => 'puts "ok"'
    }
    assert_equal expected_solution, iteration.solution
  end

  def test_multiple_files
    solution = {
      'ruby/one/file1.rb' => 'one = 1',
      'ruby/one/some/subdirectory/file2.rb' => 'two = 2',
    }
    iteration = Iteration.new(solution)
    assert_equal 'ruby', iteration.track_id
    assert_equal 'one', iteration.slug

    expected_solution = {
      'file1.rb' => 'one = 1',
      'file2.rb' => 'two = 2',
    }
    assert_equal expected_solution, iteration.solution
  end

  def test_dirty_files
    solution = {
      'ruby/one/file1.rb' => "\n\n\none = 1\ntwo = 2\n\n\n",
      'ruby/one/file2.rb' => "\n\ntwo = 2\n\nthree = 3\n",
    }
    iteration = Iteration.new(solution)
    assert_equal 'ruby', iteration.track_id
    assert_equal 'one', iteration.slug
    assert_equal "one = 1\ntwo = 2", iteration.solution['file1.rb']
    assert_equal "two = 2\n\nthree = 3", iteration.solution['file2.rb']
  end

  def test_highest_frequency_wins
    solution = {
      'ruby/one/file1.rb' => 'one = 1',
      'ruby/one/some/subdirectory/file2.rb' => 'two = 2',
      'who/knows/README.md' => 'stuff',
    }
    iteration = Iteration.new(solution)
    assert_equal 'ruby', iteration.track_id
    assert_equal 'one', iteration.slug

    expected_solution = {
      'file1.rb' => 'one = 1',
      'file2.rb' => 'two = 2',
      'README.md' => 'stuff',
    }
    assert_equal expected_solution, iteration.solution
  end
end
