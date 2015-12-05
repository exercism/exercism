require_relative '../../test_helper'
require_relative '../../../app/helpers/site_title'

class AppHelpersSiteTitleTest < Minitest::Test
  def setup
    @helper = Object.new
    @helper.extend ExercismWeb::Helpers::SiteTitle
  end

  def test_default_title
    assert_equal "exercism.io", @helper.title
  end

  def test_specified_title
    assert_equal "test title", @helper.title("test title")
  end
end
