require './test/test_helper'

require './lib/exercism/curriculum'
require './lib/exercism/language'
require './lib/exercism/trail'
require './lib/exercism/exercise'
require './lib/exercism/assignment'

# Integration tests.
# This is the entry point into the app.
class CurriculumTest < MiniTest::Unit::TestCase

  attr_reader :curriculum
  def setup
    @curriculum = Curriculum.new('./test/fixtures')
    nong = Language.new('nong', 'no', 'not')
    curriculum.add(nong, %w(one two))
  end

  def test_curriculum_takes_a_path
    assert_equal './test/fixtures', curriculum.path
  end

  def test_find_exercise_in_trail
    ex = Exercise.new('nong', 'one')
    assert_equal ex, curriculum.in('nong').find('one')
  end

  def test_get_assignment_from_trail
    path = './test/fixtures/nong/one'
    assignment = curriculum.in('nong').assign('one')
    assert_equal path, assignment.path
  end

  def test_get_assignment_from_exercise
    exercise = Exercise.new('nong', 'one')
    assignment = curriculum.assign(exercise)
    assert_equal './test/fixtures/nong/one', assignment.path
  end

end

