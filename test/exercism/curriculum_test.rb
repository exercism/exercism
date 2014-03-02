require './test/test_helper'
require './test/fixtures/fake_curricula'

require 'exercism/named'
require 'exercism/exercise'
require 'exercism/trail'
require 'exercism/curriculum'

class CurriculumTest < MiniTest::Unit::TestCase

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

end

class ConvenienceCurriculumTest < MiniTest::Unit::TestCase
  attr_reader :curriculum
  def setup
    super
    @curriculum = Curriculum.new('./test/fixtures')
    @curriculum.add FakeRubyCurriculum.new
    @curriculum.add FakeGoCurriculum.new
    Exercism.instance_variable_set(:@trails, nil)
  end

  def teardown
    super
    Exercism.instance_variable_set(:@trails, nil)
  end

  def test_trails
    Exercism.stub(:curriculum, curriculum) do
      ruby = Exercise.new('ruby', 'one')
      go = Exercise.new('go', 'one')
      assert_equal [ruby, go], Exercism.trails.map {|t| t.exercises.first}
    end
  end
end

