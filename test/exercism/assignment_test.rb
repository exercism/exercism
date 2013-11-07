require './test/test_helper'

require 'yaml'
require 'pathname'
require 'exercism/exercise'
require 'exercism/assignment'

class AssignmentTest < Minitest::Test

  attr_reader :assignment
  def setup
    @assignment = Assignment.new('fake', 'one', './test/fixtures')
  end

  def test_name
    assert_equal 'One', assignment.name
  end

  def test_detect_filenames_ignoring_example_code
    assert_equal ['Fakefile', 'one_test.test'], assignment.filenames.sort
  end

  def test_detect_files_all_the_way_down
    assignment = Assignment.new('scala', 'one', './test/fixtures')
    assert_equal ['build.sbt', 'src/test/scala/one_test.scala'].sort, assignment.filenames.sort
  end

  def test_load_testsuite
    tests = "assert 'one'\n"
    assert_equal tests, assignment.tests
  end

  def test_load_blurb
    blurb = "This is one."
    assert_equal blurb, assignment.blurb
  end

  def test_load_instructions
    instructions = "* one\n* one again\n"
    assert_equal instructions, assignment.instructions
  end

  def test_source
    assert_equal 'The internet.', assignment.source
  end

  def test_source_url
    assert_equal 'http://example.com', assignment.source_url
  end

  def test_assemble_readme
    readme = "# One\n\nThis is one.\n\n* one\n* one again\n\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    assert_equal readme, assignment.readme
  end

  def test_files
    expected = {
      "Fakefile" => "Autorun fake code\n",
      "one_test.test" => "assert 'one'\n",
      "README.md" => "THE README"
    }
    assignment.stub(:readme, "THE README") do
      assert_equal expected, assignment.files
    end
  end

  def test_sanity_check_scala_assignment
    assignment = Assignment.new('scala', 'one', './test/fixtures')
    tests = <<-END
import org.scalatest._

class OneTest extends FunSuite with Matchers {
  test ("one") {
    One.value should be (1)
  }
}
END

    build_sbt = <<-END
scalaVersion := "2.10.3"

libaryDependencies += "org.scalatest" %% "scalatest" % "2.0.RC3" % "test"
END
    expected = {
      "build.sbt" => build_sbt,
      "src/test/scala/one_test.scala" => tests,
      "README.md" => "THE README"
    }

    assignment.stub(:readme, "THE README") do
      assert_equal expected, assignment.files
    end
  end
end

