require './test/test_helper'

require 'yaml'
require 'exercism/locale'
require 'exercism/exercise'
require 'exercism/assignment'

class AssignmentTest < Minitest::Test

  attr_reader :assignment, :fake
  def setup
    super
    @fake = Locale.new('fake', 'ext', 'test')
    @assignment = Assignment.new(fake, 'one', './test/fixtures')
  end

  def test_name
    assert_equal 'One', assignment.name
  end

  def test_load_testsuite
    tests = "assert 'one'\n"
    assert_equal tests, assignment.tests
  end

  def test_load_example_code
    code = "say 'one'\n"
    assert_equal code, assignment.example
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
end

