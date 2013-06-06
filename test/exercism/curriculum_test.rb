require './test/test_helper'

require './lib/exercism/curriculum'
require './lib/exercism/locale'
require './lib/exercism/trail'
require './lib/exercism/exercise'
require './lib/exercism/assignment'

# Integration tests.
# This is the entry point into the app.
class CurriculumTest < MiniTest::Unit::TestCase

  attr_reader :curriculum
  def setup
    @curriculum = Curriculum.new('./test/fixtures')
    nong = Locale.new('nong', 'no', 'not')
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

  # Do I want an actual locale object, or just the language?
  def test_identify_language_from_filename
    filename = 'one.fp'
    femp = Locale.new('femp', 'fp', 'fpt')
    curriculum.add(femp, %w(one two))
    assert_equal 'femp', curriculum.identify_language('femp.fp')
  end

  def test_unknown_language
    assert_raises UnknownLanguage do
      curriculum.identify_language('femp.fp')
    end
  end

  def test_unstarted_trails
    femp = Locale.new('femp', 'fp', 'fpt')
    turq = Locale.new('turq', 'tq', 'tqt')
    curriculum.add(femp, %w(one two))
    curriculum.add(turq, %w(one two))
    languages = curriculum.unstarted_trails(['femp'])
    assert_equal %w(nong turq), languages
  end

end

