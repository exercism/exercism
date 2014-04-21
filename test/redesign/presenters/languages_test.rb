require_relative '../../test_helper'
require 'redesign/presenters/languages'

class PresentersLanguagesTest < MiniTest::Unit::TestCase
  def test_one_language
    assert_equal "Python", ExercismIO::Presenters::Languages.new(['Python']).to_s
  end

  def test_two_languages
    assert_equal "Python and Go", ExercismIO::Presenters::Languages.new(['Python', 'Go']).to_s
  end

  def test_more_languages
    assert_equal "Python, Scala, and Go", ExercismIO::Presenters::Languages.new(['Python', 'Scala', 'Go']).to_s
  end
end

