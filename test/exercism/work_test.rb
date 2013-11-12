require './test/integration_helper'

class WorkTest < Minitest::Test
  include DBCleaner

  def test_work_where_alice_has_commented
    alice = User.create(username: 'alice')
    bob   = User.create(username: 'bob')
    submission = Submission.create(user: bob, language: 'ruby', slug: 'anything')
    Comment.create(user: bob, submission: submission, body: 'something')
    Comment.create(user: alice, submission: submission, body: 'something')

    assert_equal [], Work.new(alice).work_for('ruby', 'anything').to_a
  end

  def test_work_where_alice_has_not_commented
    alice = User.create(username: 'alice')
    bob   = User.create(username: 'bob')
    submission = Submission.create(user: bob, language: 'ruby', slug: 'anything')

    assert_equal [submission], Work.new(alice).work_for('ruby', 'anything').to_a
  end
end
