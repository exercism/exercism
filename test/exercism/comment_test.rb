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
    # @comment2 = Comment.create(user: fred, submission: sub1, body: 'something')
  end

  def test_is_qualifying
    submission.reload
    comment = Comment.create(user: fred, submission: submission, body: 'something')
    assert_equal true, comment.qualifying?
  end

  def test_is_not_qualifying
    submission.reload
    comment = Comment.create(user: alice, submission: submission, body: 'something')
    assert_equal false, comment.qualifying?
  end

  def test_qualifying_comment_adds_to_table
    submission.reload
    comment = Comment.create(user: fred, submission: submission, body: 'something')
    comment.increment_five_a_day if comment.qualifying?
    count = FiveADayCount.where(:user_id => fred.id).first
    assert_equal 1, count.total
  end

  def test_qualifying_comment_updates_single_record_per_user_and_exercise
    submission.reload
    comments = [Comment.create(user: fred, submission: submission, body: 'something'),
                Comment.create(user: fred, submission: submission, body: 'something'),
                Comment.create(user: fred, submission: submission, body: 'something'),
                Comment.create(user: fred, submission: submission, body: 'something')]
    comments.each do |comment|
      comment.increment_five_a_day if comment.qualifying?
    end
    count = FiveADayCount.where(:user_id => fred.id).first
    assert_equal 4, count.total
    assert_equal 1, FiveADayCount.count
  end
end
