require_relative '../../test_helper'
require 'app/presenters/sharing.rb'

class SharingTest < Minitest::Test

  def submission
    submission = Object.new

    def submission.key
      "123456789"
    end

    def submission.track_id
      "ruby"
    end

    def submission.slug
      "bob"
    end

    submission
  end

  def test_creates_twitter_sharing_link
    assert_equal "<a href=\"https://twitter.com/intent/tweet?text=I just submitted the ruby bob exercise at @exercism_io - Leave me a nitpick at http://exercism.io/submissions/123456789\" id='twitter-share'>Share with Twitter</a>", Sharing.new.twitter_link(submission)
  end
end
