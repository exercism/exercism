require_relative '../../test_helper'
require 'exercism/named'
require 'json'

class PresentersAssignmentTest < Minitest::Test
  def assignments_multiple_files
    JSON.parse File.read("./test/fixtures/assignments_multiple_files.json")
  end

  def ewpa
    ExercismWeb::Presenters::Assignment
  end

  def assignment
    ewpa.from_json_data(assignments_multiple_files)
  end

  def test_build_from_json_data
    assert_instance_of ewpa, assignment
  end

  def test_select_testfiles
    testfile1, testfile2, *tail = assignment.testfiles

    assert_equal 'file1_test.name', testfile1.filename
    assert_equal 'file2_test.name', testfile2.filename

    assert_empty tail
  end

  def test_locals
    locals = assignment.to_locals

    refute_empty locals.values
  end

  def test_testfiles_class
    data = { 'foo.bar.baz' => '1', 'pi.pa.po' => '2' }
    _foobar, pipa = ewpa::Testfile.collection_from_json(data)

    assert_equal 'pi.pa.po', pipa.filename
    assert_equal 'po', pipa.extension
    assert_equal '2', pipa.content
  end

  def test_find_readme
    assert_equal 'readme_content', assignment.readme_file.content
  end

  def test_fallback_readme
    files = { 'no' => 'readme' }
    assignment = ewpa.new('track', 'slug', files)

    assert_equal 'This exercise has no readme.',
                 assignment.readme_file.content
  end
end
