require_relative '../integration_helper'

class TeamMembershipInviteTest < Minitest::Test
  include DBCleaner

  attr_reader :alice, :bob
  def setup
    super
    @alice = User.create(username: 'alice')
    @bob = User.create(username: 'bob')
  end

  def test_accept_creates_membership_and_destroys_itself
    team = Team.by(alice).defined_with(slug: 'purple')
    team.save

    membership_invite = TeamMembershipInvite.new(team: team, user: bob, inviter: alice)
    membership_invite.save

    assert_equal 0, TeamMembership.count
    assert_equal 1, TeamMembershipInvite.count

    membership_invite.accept!

    assert_equal 1, TeamMembership.count
    assert_equal 0, TeamMembershipInvite.count
  end

  def test_refuse_changes_invite_status
    team = Team.by(alice).defined_with(slug: 'purple')
    team.save

    membership_invite = TeamMembershipInvite.new(team: team, user: bob, inviter: alice)
    membership_invite.save

    refute membership_invite.refused?
    membership_invite.refuse!
    assert membership_invite.refused?
  end
end
