require './test/test_helper'
require 'app/site/languages'

class AppSiteLanguagesTest < MiniTest::Unit::TestCase
  def test_one_language
    assert_equal "Python", App::Site::Languages.new(['Python']).to_s
  end

  def test_two_languages
    assert_equal "Python and Go", App::Site::Languages.new(['Python', 'Go']).to_s
  end

  def test_more_languages
    assert_equal "Python, Scala, and Go", App::Site::Languages.new(['Python', 'Scala', 'Go']).to_s
  end
end

