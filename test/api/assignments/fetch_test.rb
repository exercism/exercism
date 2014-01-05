require './test/test_helper'
require './test/fixtures/fake_curricula'

require 'exercism/named'
require 'exercism/exercise'
require 'exercism/trail'
require 'exercism/curriculum'
require 'exercism/assignment'
require 'api/assignments/fetch'

class APIAssignmentsFetchTest < MiniTest::Unit::TestCase
  def test_fetch_assignments
    curriculum = Curriculum.new('/tmp')
    curriculum.add FakePythonCurriculum.new
    curriculum.add FakeRubyCurriculum.new
    curriculum.add FakeGoCurriculum.new

    completed = [["python", "one"], ["python", "two"], ["ruby", "one"]]
    current = [["ruby", "two"], ["ruby", "three"], ["python", "three"]]

    handler = API::Assignments::Fetch.new(completed, current, curriculum)

    expected = [
      ["go", "one"],
      ["python", "four"],
      ["python", "three"],
      ["ruby", "four"],
      ["ruby", "three"],
      ["ruby", "two"],
    ]

    assert_equal expected, handler.assignments.map {|a| [a.language, a.slug]}.sort
  end

  def test_fetch_assignments_when_at_end_of_trail
    curriculum = Curriculum.new('/tmp')
    curriculum.add FakePythonCurriculum.new

    completed = [["python", "one"], ["python", "two"], ["python", "three"], ["python", "four"]]
    current = []

    handler = API::Assignments::Fetch.new(completed, current, curriculum)

    expected = []

    assert_equal expected, handler.assignments
  end

end

