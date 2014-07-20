require_relative '../test_helper'
require 'exercism/code'

class CodeTest < Minitest::Test
  def test_extension
    code = Code.new('/path/to/file.rb')
    assert_equal 'rb', code.extension
  end

  def test_track
    code = Code.new('/path/to/file.rb')
    assert_equal 'path', code.track
  end

  def test_slug
    code = Code.new('/path/to/file.rb')
    assert_equal 'to', code.slug
  end

  def test_filename
    code = Code.new('/path/to/file.rb')
    assert_equal 'file.rb', code.filename
  end

  def test_slug_in_scala
    code = Code.new('scala/leap/src/main/scala/leap.scala')
    assert_equal 'leap', code.slug
  end

  def test_windows_file_path
    code = Code.new('\path\to\file.py')
    assert_equal 'path', code.track
    assert_equal 'to', code.slug
    assert_equal 'file.py', code.filename
  end

  def test_windows_scala_file_path
    code = Code.new("scala\\bob\\src\\main\\scala\\bob.scala")
    assert_equal 'scala', code.track
    assert_equal 'bob', code.slug
    assert_equal 'bob.scala', code.filename
  end

  def test_case_insensitive_slug_and_track
    code = Code.new('/Path/To/File.py')
    assert_equal 'path', code.track
    assert_equal 'to', code.slug
  end
end
