require_relative '../../test_helper'
require_relative '../../../app/helpers/user_progress_bar'

class AppHelperUserProgressBarTest < Minitest::Test
  def setup
    @helper = Object.new
    @helper.extend ExercismWeb::Helpers::UserProgressBar
  end

  def create_progress_mock(user_exe, lang_tracks, calls: 1)
    language_progress = Minitest::Mock.new
    calls.times do
      language_progress.expect(:user_exercises, Array.new(user_exe || 0, true))
      language_progress.expect(:language_track, Array.new(lang_tracks || 0, true))
    end
    language_progress
  end

  def test_percent_100
    progress_mock = create_progress_mock 1, 1
    assert_equal '100', @helper.percent(progress_mock)
  end

  def test_percent_decimal
    progress_mock = create_progress_mock 1, 3
    assert_equal '33', @helper.percent(progress_mock)
  end

  def test_percent_0
    progress_mock = create_progress_mock 0, 1
    assert_equal '0', @helper.percent(progress_mock)
  end

  def test_infinity
    progress_mock = create_progress_mock 0, 0
    assert_equal '0', @helper.percent(progress_mock)
  end

  def test_nil
    progress_mock = create_progress_mock 0, nil
    assert_equal '0', @helper.percent(progress_mock)
  end

  def test_missing
    progress_mock = create_progress_mock nil, 0
    assert_equal '0', @helper.percent(progress_mock)
  end

  def test_progress_ratio_javascript_50_percent
    progress_mock = create_progress_mock 25, 50, calls: 2
    progress_mock.expect(:language, 'Javascript')
    assert_equal 'Javascript: 25/50 (50%)', @helper.progress_ratio(progress_mock)
  end
end
