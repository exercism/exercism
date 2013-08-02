require './test/test_helper'
require 'app/helpers/site_title_helper'

class SiteTitleHelperTest < Minitest::Test

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(Sinatra::SiteTitleHelper)
    @helper
  end

  def test_default_title
    assert_equal "exercism.io", helper.title
  end

  def test_title
    helper.stub(:title, "word-count") do
      assert_equal "word-count", helper.title
    end
  end

end
