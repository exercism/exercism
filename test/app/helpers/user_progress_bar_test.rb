require_relative '../../test_helper'
require_relative '../../../app/helpers/user_progress_bar'

class AppHelperUserProgressBarTest < Minitest::Test
  def setup
    @helper = Object.new
    @helper.extend ExercismWeb::Helpers::UserProgressBar
  end

  def test_percent_100
    assert_equal '100', @helper.percent([1, 1])
  end

  def test_percent_decimal
    assert_equal '33', @helper.percent([1, 3])
  end

  def test_percent_0
    assert_equal '0', @helper.percent([0, 1])
  end

  def test_infinity
    assert_equal '0', @helper.percent([0, 0])
  end

  def test_nil
    assert_equal '0', @helper.percent([0, nil])
  end

  def test_missing
    assert_equal '0', @helper.percent([0])
  end

  def test_progress_ratio_javascript_50_percent
    assert_equal 'Javascript: 25/50 (50%)', @helper.progress_ratio('Javascript', [25, 50])
  end
end
