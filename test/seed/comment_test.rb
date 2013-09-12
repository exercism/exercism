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
    expected = {
      user: user,
      comment: 'O HAI',
      at: now
    }
    assert_equal expected, comment.by(user)
  end
end
