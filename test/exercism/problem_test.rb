require_relative '../test_helper'
require 'exercism/named'
require 'exercism/problem'
require 'exercism/language'

class ExerciseTest < Minitest::Test
  def setup
    Language.instance_variable_set(:"@by_track_id", "cpp" => "C++", "go" => "Go")
  end

  def teardown
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  def test_attributes
    problem = Problem.new('go', 'one')

    assert_equal 'go', problem.track_id
    assert_equal 'one', problem.slug
  end

  def test_language
    problem = Problem.new('cpp', 'one')
    assert_equal 'C++', problem.language
  end

  def test_name
    problem = Problem.new('go', 'one')
    assert_equal 'One', problem.name
  end

  def test_compound_problem_name
    problem = Problem.new('go', 'one-and-two')
    assert_equal 'One And Two', problem.name
  end

  def test_to_s
    problem = Problem.new('go', 'one')
    assert_equal 'Problem: one (Go)', problem.to_s
  end

  def test_in_p
    problem = Problem.new('go', 'one')
    assert problem.in?('go')
    refute problem.in?('clojure')
  end
end
