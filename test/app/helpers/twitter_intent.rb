require 'active_support/all'
require_relative '../../test_helper'
require_relative '../../../app/helpers/twitter_intent'

class TwitterIntentTest < Minitest::Test
  TWITTER_URL = 'https://twitter.com/intent/tweet?'.freeze

  def test_no_params
    assert_equal TWITTER_URL, helper.twitter_share
  end

  def test_using_text
    text = 'A #hashtag for @you http://exercism.io'
    expected_uri =
      "#{TWITTER_URL}%s" %
      'text=A+%23hashtag+for+%40you+http%3A%2F%2Fexercism.io'

    assert_equal expected_uri, helper.twitter_share(text: text)
  end

  def test_using_text_and_url
    text = 'A #hashtag for @you'
    url = 'http://exercism.io'
    expected_uri =
      "#{TWITTER_URL}%s" %
      'text=A+%23hashtag+for+%40you&url=http%3A%2F%2Fexercism.io'

    assert_equal expected_uri, helper.twitter_share(text: text, url: url)
  end

  def test_using_url
    url = 'http://exercism.io'
    expected_uri = "#{TWITTER_URL}%s" % 'url=http%3A%2F%2Fexercism.io'

    assert_equal expected_uri, helper.twitter_share(url: url)
  end

  def test_other_params_are_ignored
    text = 'Go for it!'
    expected_uri = "#{TWITTER_URL}text=Go+for+it%21"
    assert_equal expected_uri, helper.twitter_share(text: text, go: 'No go')
  end

  def test_from_submission
    expected_uri = "#{TWITTER_URL}text=I+just+submitted+the+%23Elixir+raindrops"\
    "+exercise+at+%40exercism_io+-+Leave+me+a+nitpick+at+"\
    "&url=http%3A%2F%2Fexercism.io%2Fsubmissions%2F0b7122bb15044990a62717315ea68dd6"
    problem = OpenStruct.new(language: 'Elixir')
    submission =
      OpenStruct.new(problem: problem,
                     slug: 'raindrops',
                     key: '0b7122bb15044990a62717315ea68dd6')
    assert_equal expected_uri, helper.twitter_share_from_submission(submission)
  end

  private

  def helper
    @helper ||= Object.new.extend(ExercismWeb::Helpers::TwitterIntent)
  end
end
