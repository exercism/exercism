require_relative '../integration_helper'

class TeamMembershipRequestTest < Minitest::Test
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

    membership_request = TeamMembershipRequest.new(team: team, user: bob)
    membership_request.save

    assert_equal 0, TeamMembership.count
    assert_equal 1, TeamMembershipRequest.count

    membership_request.accept!

    assert_equal 1, TeamMembership.count
    assert_equal 0, TeamMembershipRequest.count
  end

  def test_refuse_changes_invite_status
    team = Team.by(alice).defined_with(slug: 'purple')
    team.save

    membership_request = TeamMembershipRequest.new(team: team, user: bob)
    membership_request.save

    refute membership_request.refused?
    membership_request.refuse!
    assert membership_request.refused?
  end
end
