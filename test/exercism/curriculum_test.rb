require './test/test_helper'

require 'exercism/curriculum'
require 'exercism/locale'
require 'exercism/trail'
require 'exercism/exercise'
require 'exercism/assignment'

class NongCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('nong', 'no', 'not')
  end
end

class FempCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('femp', 'fp', 'fpt')
  end
end

# Integration tests.
# This is the entry point into the app.
class CurriculumTest < Minitest::Test

  attr_reader :curriculum
  def setup
    @curriculum = Curriculum.new('./test/fixtures')
    curriculum.add NongCurriculum.new
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
    curriculum.add FempCurriculum.new
    assert_equal 'femp', curriculum.identify_language('one.fp')
  end

  def test_unknown_language
    assert_raises Exercism::UnknownLanguage do
      curriculum.identify_language('femp.fp')
    end
  end

  def test_unstarted_trails
    curriculum.add FempCurriculum.new
    languages = curriculum.unstarted_trails(['femp'])
    assert_equal ['nong'], languages
  end

end

