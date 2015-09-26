require_relative '../integration_helper'
require 'minitest/pride'

class CommentTest < Minitest::Test
  include DBCleaner

  attr_reader :alice, :fred, :comment, :submission
  def setup
    super
    @alice = User.create(username: 'alice')
    @fred = User.create(username: 'fred')
    @submission = Submission.create(user: alice, language: 'python', slug: 'one')
  end

  def test_is_qualifying
    submission.reload
    qualifying_comment = Comment.create(user: fred, submission: submission, body: 'something')
    non_qualifying_comment = Comment.create(user: alice, submission: submission, body: 'something')
    assert qualifying_comment.qualifying?
    refute non_qualifying_comment.qualifying?
  end
end
