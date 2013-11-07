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

  def test_detect_files_ignoring_example_code
    assert_equal ['one_test.test', 'one_stub.ext'], assignment.files
  end

  def test_detect_files_all_the_way_down
    assignment = Assignment.new('scala', 'one', './test/fixtures')
    assert_equal ['build.sbt', 'src/test/scala/one_test.scala'].sort, assignment.files.sort
  end

  def test_load_stub
    stub = "say <something>\n"
    assert_equal stub, assignment.stub
  end

  def test_stub_filename
    assert_equal "one.ext", assignment.stub_file
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

  def test_default_additional_files
    additional_files = {}
    assert_equal additional_files, assignment.additional_files
  end
end

class AssignmentTestNoStub < Minitest::Test

  attr_reader :assignment
  def setup
    @assignment = Assignment.new('fake', 'two', './test/fixtures')
  end

  def test_load_stub
    assert_equal nil, assignment.stub
  end

  def test_stub_filename
    assert_equal nil, assignment.stub_file
  end
end

