require_relative '../test_helper'
require 'exercism/iteration'
require 'exercism/code'

class IterationTest < Minitest::Test
  def test_single_file
    solution = {
      'ruby/one/file.rb' => 'puts "ok"',
    }
    opts = {code_anaysis: 'a1', test_analysis: 'a2', track: 'ruby', slug: 'one'}
    iteration = Iteration.new(solution, opts)
    assert_equal 'ruby', iteration.track
    assert_equal 'one', iteration.slug
    assert_equal solution, iteration.solution
  end

  def test_multiple_files
   solution = {
     'ruby/one/file1.rb' => 'one = 1',
     'ruby/one/file2.rb' => 'two = 2',
   }
   
   opts = {code_anaysis: 'a1', test_analysis: 'a2', track: 'ruby', slug: 'one'}
   iteration = Iteration.new(solution, opts)
   assert_equal 'ruby', iteration.track
   assert_equal 'one', iteration.slug
   assert_equal solution, iteration.solution
  end

  def test_dirty_files
   solution = {
     'ruby/one/file1.rb' => "\n\n\none = 1\ntwo = 2\n\n\n",
     'ruby/one/file2.rb' => "\n\ntwo = 2\n\nthree = 3\n",
   }

   opts = {code_anaysis: 'a1', test_analysis: 'a2', track: 'ruby', slug: 'one'}
   iteration = Iteration.new(solution, opts)
   assert_equal 'ruby', iteration.track
   assert_equal 'one', iteration.slug
   assert_equal "one = 1\ntwo = 2", iteration.solution['ruby/one/file1.rb']
   assert_equal "two = 2\n\nthree = 3", iteration.solution['ruby/one/file2.rb']
  end

  def test_highest_frequency_wins
   solution = {
     'ruby/one/file1.rb' => 'one = 1',
     'ruby/one/file2.rb' => 'two = 2',
     'who/knows/README.md' => 'stuff',
   }
  
   opts = {code_anaysis: 'a1', test_analysis: 'a2', track: 'ruby', slug: 'one'}
   iteration = Iteration.new(solution, opts)
   assert_equal 'ruby', iteration.track
   assert_equal 'one', iteration.slug
   assert_equal solution, iteration.solution
  end
end
