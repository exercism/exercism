require_relative '../test_helper'
require 'exercism/iteration'

class IterationTest < Minitest::Test
  def test_nix_files
    solution = {
      'ruby/one/file.rb' => 'puts "ok"',
      'ruby/one/some/subdirectory/file2.rb' => 'two = 2',
    }
    iteration = Iteration.new(solution, 'ruby', 'one')
    assert_equal 'ruby', iteration.track_id
    assert_equal 'one', iteration.slug

    expected_solution = {
      'file.rb' => 'puts "ok"',
      'some/subdirectory/file2.rb' => 'two = 2',
    }
    assert_equal expected_solution, iteration.solution
  end

  def test_win_files
    solution = {
      'ruby\one\file.rb' => 'puts "ok"',
      'ruby\one\some\subdirectory\file2.rb' => 'two = 2',
    }
    iteration = Iteration.new(solution, 'ruby', 'one')
    assert_equal 'ruby', iteration.track_id
    assert_equal 'one', iteration.slug

    expected_solution = {
      'file.rb' => 'puts "ok"',
      'some/subdirectory/file2.rb' => 'two = 2',
    }
    assert_equal expected_solution, iteration.solution
  end

  def test_path_filter_is_case_insensitive
    fixture = { filename: 'somefile.rb', content: 'some ruby code'}
    solution = { "Ruby/One/#{fixture[:filename]}" => fixture[:content]}
    iteration = Iteration.new(solution, 'ruby', 'one')
    expected_solution = { fixture[:filename] => fixture[:content] }
    assert_equal expected_solution, iteration.solution
  end

end
