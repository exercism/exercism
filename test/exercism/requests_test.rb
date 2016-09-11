require_relative '../app_helper'
require 'mocha/setup'

class RequestsTest < Minitest::Test
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

  attr_reader :alice, :bob
  def setup
    super
    @alice = User.create(alice_attributes)
    @bob = User.create(bob_attributes)
  end

  def assert_response_status(expected_status)
    assert_equal expected_status, last_response.status
  end

  def test_user_must_be_logged_in
    [
      [:post, '/teams/abc/requests'],
      [:post, '/teams/abc/request/xyz/accept'],
      [:post, '/teams/abc/request/xyz/refuse'],
    ].each do |verb, endpoint|
      send verb, endpoint
      assert_equal 302, last_response.status
      location = "http://example.org/please-login?return_path=#{endpoint}"
      assert_equal location, last_response.location, "Wrong redirect for #{verb.to_s.upcase} #{endpoint}"
    end
  end

  def test_user_must_be_manager_to_respond_to_a_request
    team = Team.by(alice).defined_with(slug: 'abc')
    team.save

    TeamMembershipRequest.create!(user: bob, team: team)

    [
      [:post, '/teams/abc/request/bob/accept', "accept request"],
      [:post, '/teams/abc/request/bob/refuse', "refuse request"],
    ].each do |verb, path, action|
      send verb, path, {}, login(bob)
      assert_equal 302, last_response.status, "No redirect for #{verb.to_s.upcase} #{path}"
      location = "http://example.org/teams/abc"
      assert_equal location, last_response.location, "Only a manager may #{action}. (#{verb.to_s.upcase} #{path})"
    end
  end

  def test_request_membership
    team = Team.by(alice).defined_with(slug: 'members')
    team.save

    refute bob.team_membership_requests.where(team_id: team).exists?
    post "/teams/#{team.slug}/requests", {}, login(bob)
    assert bob.team_membership_requests.where(team_id: team).exists?
  end

  def test_accept_membership
    team = Team.by(alice).defined_with(slug: 'members')
    team.save

    TeamMembershipRequest.create!(user: bob, team: team)

    assert TeamMembershipRequest.where(team_id: team, user: bob, refused: false).exists?
    refute team.includes?(bob)
    post "/teams/#{team.slug}/request/bob/accept", {}, login(alice)
    refute TeamMembershipRequest.where(team_id: team, user: bob).exists?
    assert team.includes?(bob)
  end

  def test_refuse_membership
    team = Team.by(alice).defined_with(slug: 'members')
    team.save

    TeamMembershipRequest.create!(user: bob, team: team)

    refute team.includes?(bob)
    assert TeamMembershipRequest.where(team_id: team, user: bob, refused: false).exists?
    post "/teams/#{team.slug}/request/bob/refuse", {}, login(alice)
    refute team.includes?(bob)
    assert TeamMembershipRequest.where(team_id: team, user: bob, refused: true).exists?
  end
end
