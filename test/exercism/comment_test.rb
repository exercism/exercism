require_relative '../integration_helper'
require 'minitest/pride'

class CommentTest < Minitest::Test
  include DBCleaner

  def test_qualifies_for_five_a_day
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    submission = Submission.create(user: alice, language: 'python', slug: 'one')
    c1 = Comment.create(user: bob, submission: submission, body: 'something')
    c2 = Comment.create(user: alice, submission: submission, body: 'something')
    assert c1.qualifying?, "Commenting on someone else's submission should qualify as one of your five a day."
    refute c2.qualifying?, "Should not get credit for commenting on your own submission"
  end

  def test_mentions
    User.create(username: 'alice')
    User.create(username: 'bob')
    [
      ["", [], "empty comment"],
      ["Mention @alice", ["alice"], "basic mention"],
      ["Mention @alice and @bob", %w(alice bob), "mention multiple users"],
      ["`@alice` and @bob", ["bob"], "mention-like thing within in-line code"],
      ["```\n@alice\n```\n\nand @bob", ["bob"], "mention-like thing within fenced code block"],
      ["Mention @alice and @bob and also @charlie", %w(alice bob), "ignore unknown users"],
    ].each do |body, mentions, _desc|
      usernames = User.where(id: Comment.new(body: body).mention_ids).map(&:username)
      assert_equal mentions, usernames.sort
    end
  end

  def test_filter_by_submission_language
    alice = User.create(username: "alice")
    s1 = Submission.create(user: alice, language: "python", slug: "one")
    c1 = Comment.create(user: alice, submission: s1, body: "python comment")
    s2 = Submission.create(user: alice, language: "ruby", slug: "one")
    c2 = Comment.create(user: alice, submission: s2, body: "ruby comment")

    comments = alice.comments.in_track("ruby")
    assert_equal 1, comments.size
    assert_equal "ruby comment", comments.first.body
  end
end
