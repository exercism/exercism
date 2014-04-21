require_relative '../approval_helper'

require 'services/message'
require 'services/team_invitation_message'
require 'exercism/named'
require 'exercism/exercise'

class TeamInvitationMessageTest < MiniTest::Unit::TestCase

  FakeUser = Struct.new(:username, :email)
  FakeTeam = Struct.new(:name)

  attr_reader :alice, :bob, :team

  def setup
    @bob = FakeUser.new('bob', 'bob@example.com')
    @alice = FakeUser.new('alice', 'alice@example.com')
    @team = FakeTeam.new('Test')
  end

  def dispatch
    @dispatch ||= TeamInvitationMessage.new(
      instigator: alice,
      target: {
        team_name: team.name,
        invitee: bob
      },
      site_root: "example.com"
    )
  end

  def test_subject
    assert_equal "alice has invited you to join team Test", dispatch.subject
  end

  def test_body
    Approvals.verify(dispatch.body, name: 'team_invitation_email_body')
  end

end
