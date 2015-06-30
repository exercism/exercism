require_relative '../../integration_helper'

class ParticipantTest < Minitest::Test
  include DBCleaner

  def test_participants
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    charlie = User.create(username: 'charlie')

    s1 = Submission.create(state: 'superseded', user: alice, language: 'ruby', slug: 'one')
    s1.comments << Comment.new(user: bob, body: 'nice')
    s1.save

    s2 = Submission.create(state: 'pending', user: alice, language: 'ruby', slug: 'one')
    s2.comments << Comment.new(user: charlie, body: 'pretty good')
    s2.save

    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'one').update

    s2.reload
    participants = Participants.in(s2).map(&:username).sort

    assert_equal %w(alice bob charlie), participants
  end

  def test_participants_with_mentions
    alice = User.create(username: 'alice')
    _ = User.create(username: 'bob')
    charlie = User.create(username: 'charlie')
    _ = User.create(username: 'mention_user')

    s1 = Submission.create(state: 'superseded', user: alice, language: 'ruby', slug: 'one')
    s1.comments << Comment.new(user: alice, body: 'What about @bob?')
    s1.save

    s2 = Submission.create(state: 'pending', user: alice, language: 'ruby', slug: 'one')
    s2.comments << Comment.new(user: charlie, body: '@mention_user should have bleh')
    s2.save

    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'one').update

    s2.reload
    participants = Participants.in(s2).map(&:username).sort

    assert_equal %w(alice charlie mention_user), participants
  end

end
