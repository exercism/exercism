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
  end

  def test_curriculum_takes_a_path
    assert_equal './test/fixtures', curriculum.path
  end

  def test_add_trail_to_curriculum
    nong = Language.new('nong', 'no', 'not')
    curriculum.add(nong, %w(one two))

    ex = Exercise.new('nong', 'one')
    assert_equal ex, curriculum.in('nong').find('one')
  end

  def test_get_assignment_from_trail
    nong = Language.new('nong', 'no', 'not')
    curriculum.add(nong, %w(one two))

    path = './test/fixtures/nong/one'
    assignment = curriculum.in('nong').assign('one')
    assert_equal path, assignment.path
  end

end
