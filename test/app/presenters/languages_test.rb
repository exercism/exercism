require_relative '../../test_helper'
require_relative '../../../app/presenters/languages'

class PresentersLanguagesTest < Minitest::Test
  def test_one_language
    assert_equal "Python", ExercismWeb::Presenters::Languages.new(['Python']).to_s
  end

  def test_two_languages
    assert_equal "Python and Go", ExercismWeb::Presenters::Languages.new(['Python', 'Go']).to_s
  end

  def test_more_languages
    assert_equal "Python, Scala, and Go", ExercismWeb::Presenters::Languages.new(['Python', 'Scala', 'Go']).to_s
  end
end
