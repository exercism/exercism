require './test/test_helper'
require 'time'
require 'seed/comment'

class SeedCommentTest < Minitest::Test
  def now
    @now ||= Time.now
  end

  def test_attributes
    comment = Seed::Comment.new('O HAI', now)
    user = Object.new
    submission = Object.new
    expected = {
      user: user,
      body: 'O HAI',
      at: now,
      submission: submission
    }
    assert_equal expected, comment.by(user, on: submission)
  end
end
