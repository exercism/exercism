require './test/test_helper'
require 'pathname'

require 'exercism/locale'
require 'exercism/assignment'

class ScalaAssignmentTest < Minitest::Test

  attr_reader :assignment, :scala
  def setup
    super
    @scala = ScalaLocale.new('scala', 'scala', 'scala')
    @assignment = Assignment.new(scala, 'one', './test/fixtures')
  end

  def test_load_testsuite
    tests = <<-END
import org.scalatest._

class OneTest extends FunSuite with Matchers {
  test ("one") {
    One.value should be (1)
  }
}
END
    assert_equal tests, assignment.tests
  end

  def test_additional_files
    build_sbt = <<-END
scalaVersion := "2.10.3"

libaryDependencies += "org.scalatest" %% "scalatest" % "2.0.RC3" % "test"
END
    additional_files = { "build.sbt" => build_sbt }

    assert_equal additional_files, assignment.additional_files
  end
end
