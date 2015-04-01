require_relative '../../test_helper'
require 'app/helpers/site_title_helper'

class SiteTitleHelperTest < Minitest::Test
  def setup
    @helper = Object.new
    @helper.extend Sinatra::SiteTitleHelper
  end

  def test_default_title
    assert_equal "exercism.io", @helper.title
  end

  def test_specified_title
    assert_equal "test title", @helper.title("test title")
  end
end
