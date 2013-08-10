require './test/test_helper'

require 'exercism/locale'
require 'exercism/exercise'
require 'exercism/assignment'
require 'exercism/trail'
require 'exercism/curriculum'

class FakeRubyCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('ruby', 'rb', 'rb')
  end
end

class FakeGoCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('go', 'go', 'go')
  end
end

# Integration tests.
# This is the entry point into the app.
class CurriculumTest < Minitest::Test

  attr_reader :curriculum
  def setup
    @curriculum = Curriculum.new('./test/fixtures')
    curriculum.add FakeRubyCurriculum.new
  end

  def test_curriculum_takes_a_path
    assert_equal './test/fixtures', curriculum.path
  end

  def test_find_exercise_in_trail
    ex = Exercise.new('ruby', 'one')
    assert_equal ex, curriculum.in('ruby').find('one')
  end

  def test_get_assignment_from_trail
    assignment = curriculum.in('ruby').assign('one')
    assert_equal './test/fixtures/ruby/one', assignment.path
  end

  def test_get_assignment_from_curriculum
    exercise = Exercise.new('ruby', 'one')
    assignment = curriculum.assign(exercise)
    assert_equal './test/fixtures/ruby/one', assignment.path
  end

  def test_identify_language_from_filename
    curriculum.add FakeGoCurriculum.new
    assert_equal 'go', curriculum.identify_language('one.go')
  end

  def test_unknown_language
    assert_raises Exercism::UnknownLanguage do
      curriculum.identify_language('femp.fp')
    end
  end

  def test_unstarted_trails
    curriculum.add FakeGoCurriculum.new
    languages = curriculum.unstarted_trails(['go'])
    assert_equal ['ruby'], languages
  end
end

