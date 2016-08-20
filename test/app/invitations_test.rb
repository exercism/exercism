require_relative '../app_helper'
require 'mocha/setup'

class InvitationsTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def alice_attributes
    {
      username: 'alice',
      github_id: 1,
      email: "alice@example.com",
    }
  end

  def bob_attributes
    {
      username: 'bob',
      github_id: 2,
      track_mentor: ['ruby'],
      email: "bob@example.com",
    }
  end

  def charlie_attributes
    {
      username: 'charlie',
      github_id: 3,
      track_mentor: ['ruby'],
      email: "charlie@example.com",
    }
  end

  attr_reader :alice, :bob, :charlie
  def setup
    super
    @alice = User.create(alice_attributes)
    @bob = User.create(bob_attributes)
    @charlie = User.create(charlie_attributes)
  end

  def assert_response_status(expected_status)
    assert_equal expected_status, last_response.status
  end

  def test_user_must_be_logged_in
    [
      [:post, '/teams/abc/invitations'],
      [:post, '/teams/abc/invitation/accept'],
      [:post, '/teams/abc/invitation/refuse'],
    ].each do |verb, endpoint|
      send verb, endpoint
      assert_equal 302, last_response.status
      location = "http://example.org/please-login?return_path=#{endpoint}"
      assert_equal location, last_response.location, "Wrong redirect for #{verb.to_s.upcase} #{endpoint}"
    end
  end

  def test_user_must_be_manager
    team = Team.by(alice).defined_with(slug: 'abc', usernames: bob.username)
    team.save
    TeamMembershipInvite.pending.find_by(user: bob, team: team).accept!

    verb, path, action = [:post, '/teams/abc/invitations', "invite members"]
    location = "http://example.org/teams/abc"

    send verb, path, {}, login(bob)
    assert_equal 302, last_response.status, "No redirect for #{verb.to_s.upcase} #{path}"
    assert_equal location, last_response.location, "Only a manager may #{action}. (#{verb.to_s.upcase} #{path})"
  end

  def test_invitation
    team = Team.by(alice).defined_with(slug: 'members')
    team.save

    refute TeamMembershipInvite.exists?

    post "/teams/#{team.slug}/invitations", { usernames: "#{bob.username}, #{charlie.username}" }, login(alice)

    assert_equal 1, bob.reload.team_membership_invites.count
    assert_equal 1, charlie.reload.team_membership_invites.count

    refute team.includes?(bob)
    refute team.includes?(charlie)
  end

  def test_only_managers_can_invite_members
    team = Team.by(alice).defined_with(slug: 'members', usernames: bob.username)
    team.save

    post "/teams/#{team.slug}/invitations", { usernames: charlie.username }, login(bob)

    team.reload

    assert_response_status(302)
    refute team.includes?(charlie)
  end

  def test_accept_invitation
    team_name = 'abc'
    post '/teams/new', { team: { slug: team_name, usernames: bob.username } }, login(alice)

    assert_equal 1, bob.team_membership_invites.count, "Bob should have membership invite for the team."
    assert_equal 0, bob.team_memberships.count, "Bob should not have a membership for the team."

    post "/teams/abc/invitation/accept", { usernames: bob.username }, login(bob)

    assert_equal 0, bob.reload.team_membership_invites.count, "Bob should not have a membership invite."
    assert_equal 1, bob.reload.team_memberships.count, "Bob should have a membership."
  end

  def test_refuse_invitation
    team_name = 'abc'
    post '/teams/new', { team: { slug: team_name, usernames: bob.username } }, login(alice)

    assert_equal 1, bob.team_membership_invites.count, "Bob should have a membership invite for the team."
    assert_equal 0, bob.team_memberships.count, "Bob should not have a membership for the team."

    post "/teams/abc/invitation/refuse", { usernames: bob.username }, login(bob)

    bob_invitations = TeamMembershipInvite.where(user: bob)

    assert_equal 1, bob_invitations.count, "Bob should still have membership invite record."
    assert bob_invitations.last.refused?, "Bob membership invite should be refused."
    assert_equal 0, bob.reload.team_memberships.count, "Bob should not have a membership."
  end
end
