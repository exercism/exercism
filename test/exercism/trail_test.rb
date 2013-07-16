require './test/test_helper'

require 'exercism/locale'
require 'exercism/exercise'
require 'exercism/trail'

class TrailTest < MiniTest::Unit::TestCase

  attr_reader :trail, :one, :two
  def setup
    nong = Locale.new('nong', 'no', 'not')
    @trail = Trail.new(nong, ['one', 'two'], '/tmp')
    @one = Exercise.new('nong', 'one')
    @two = Exercise.new('nong', 'two')
  end

  def test_language
    assert_equal 'nong', trail.language
  end

  def test_first_exercise_on_trail
    assert_equal one, trail.first
  end

  def test_successive_exercises
    assert_equal two, trail.successor(one)
  end

  def test_level_up
    ruby = Locale.new('ruby', 'rb', 'rb')
    slugs = %w(bob phrase rna garden cake banana)
    trail = Trail.new(ruby, slugs, '/tmp')

    cake = Exercise.new('ruby', 'cake')
    exercise = trail.after(cake, %w(bob phrase garden))
    assert_equal Exercise.new('ruby', 'rna'), exercise
  end
end

