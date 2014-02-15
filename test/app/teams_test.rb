require './test/app_helper'
require 'mocha/setup'

class TeamsTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismApp
  end

  def alice_attributes
    {
      username: 'alice',
      github_id: 1,
      email: "alice@example.com"
    }
  end

  def bob_attributes
    {
      username: 'bob',
      github_id: 2,
      mastery: ['ruby'],
      email: "bob@example.com"
    }
  end

  def charlie_attributes
    {
      username: 'charlie',
      github_id: 3,
      mastery: ['ruby'],
      email: "charlie@example.com"
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
      [:get, '/teams'],
      [:post, '/teams'],
      [:get, '/teams/abc'],
      [:delete, '/teams/abc'],
      [:post, '/teams/abc/members'],
      [:put, '/teams/abc/leave'],
      [:delete, '/teams/abc/members/alice'],
      [:put, '/teams/abc'],
      [:put, '/teams/abc/confirm']
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

    [
      [:delete, '/teams/abc', "delete a team"],
      [:put, '/teams/abc', "edit a team"],
      [:post, '/teams/abc/members', "add members"],
      [:delete, '/teams/abc/members/bob', "dismiss members"],
    ].each do |verb, path, action|
      send verb, path, {}, login(bob)
      assert_equal 302, last_response.status, "No redirect for #{verb.to_s.upcase} #{path}"
      location = "http://example.org/account"
      assert_equal location, last_response.location, "Only a manager my #{action}. (#{verb.to_s.upcase} #{path})"
    end
  end

  def test_user_must_be_on_team_to_view_team_page
    team = Team.by(alice).defined_with(slug: 'abc', usernames: bob.username)
    team.save

    get '/teams/abc', {}, login(alice)
    assert_equal 200, last_response.status

    get '/teams/abc', {}, login(bob)
    assert_equal 302, last_response.status
    assert_equal "http://example.org/", last_response.location

    team.confirm(bob.username)
    get '/teams/abc', {}, login(bob)
    assert_equal 200, last_response.status

    get '/teams/abc', {}, login(charlie)
    assert_equal 302, last_response.status
    assert_equal "http://example.org/", last_response.location
  end

  def test_team_creation_without_name_uses_slug
    post '/teams', {team: {slug: 'no_members', usernames: ""}}, login(alice)
    team = Team.first

    assert_equal 'no_members', team.name
  end

  def test_team_creation_with_empty_name_uses_slug
    post '/teams', {team: {slug: 'no_members', name: '', usernames: ''}}, login(alice)
    team = Team.first

    assert_equal 'no_members', team.name
  end

  def test_team_creation_with_name
    post '/teams', {team: {name: 'No Members', slug: 'no_members', usernames: ""}}, login(alice)
    team = Team.first

    assert_equal 'No Members', team.name
  end

  def test_team_creation_with_no_members
    assert_equal 0, alice.teams_created.size

    post '/teams', {team: {slug: 'no_members', usernames: ""}}, login(alice)

    team = Team.first

    alice.reload
    assert_equal 1, alice.teams_created.size
    assert_equal alice, team.creator
  end

  def test_team_creation_with_no_slug
    post '/teams', {team: {usernames: bob.username}}, login(alice)

    assert_equal 0, alice.teams_created.size
  end

  def test_team_creation_with_multiple_members
    TeamInvitationMessage.stub(:ship, nil) do
      post '/teams', {team: {slug: 'members', usernames: "#{bob.username},#{charlie.username}"}}, login(alice)

      team = Team.first

      bob.reload
      charlie.reload

      assert_equal 0, bob.teams.size
      assert_equal 0, charlie.teams.size

      assert team.includes?(alice)
      refute team.includes?(bob)
      refute team.includes?(charlie)

      put "/teams/#{team.slug}/confirm", {}, login(bob)
      put "/teams/#{team.slug}/confirm", {}, login(charlie)

      bob.reload
      charlie.reload

      assert_equal 1, bob.teams.size
      assert_equal 1, charlie.teams.size

      [alice, bob, charlie].each do |member|
        assert team.includes?(member)
      end
    end
  end

  def test_member_addition
    TeamInvitationMessage.stub(:ship, nil) do
      team = Team.by(alice).defined_with({slug: 'members'})
      team.save

      post "/teams/#{team.slug}/members", {usernames: "#{bob.username},#{charlie.username}"}, login(alice)

      team.reload

      refute team.includes?(bob)
      refute team.includes?(charlie)

      put "/teams/#{team.slug}/confirm", {}, login(bob)

      team.reload

      assert team.includes?(bob)
      refute team.includes?(charlie)
    end
  end

  def test_member_addition_without_being_creator
    team = Team.by(alice).defined_with({slug: 'members', usernames: bob.username})
    team.save

    post "/teams/#{team.slug}/members", {usernames: charlie.username}, login(bob)

    team.reload

    assert_response_status(302)
    refute team.includes?(charlie)
  end

  def test_member_removal
    team = Team.by(alice).defined_with({slug: 'awesome', usernames: "#{bob.username},#{charlie.username}"})
    team.save

    put "/teams/#{team.slug}/confirm", {}, login(bob)
    delete "/teams/#{team.slug}/members/#{bob.username}", {}, login(alice)

    team.reload

    refute team.includes?(bob)
  end

  def test_leave_team
    team = Team.by(alice).defined_with({slug: 'awesome', usernames: "#{bob.username},#{charlie.username}"})
    team.save

    put "/teams/#{team.slug}/confirm", {}, login(bob)
    put "/teams/#{team.slug}/leave", {}, login(bob)

    team.reload

    refute team.includes?(bob)
  end

  def test_member_removal_without_being_creator
    team = Team.by(alice).defined_with({slug: 'members', usernames: "#{bob.username},#{charlie.username}"})
    team.save

    put "/teams/#{team.slug}/confirm", {}, login(charlie)
    delete "/teams/#{team.slug}/members/#{charlie.username}", {}, login(bob)

    team.reload

    assert_response_status(302)
    assert team.includes?(charlie)
  end

  def test_view_a_team_as_a_member
    team = Team.by(alice).defined_with({slug: 'members', usernames: "#{bob.username},#{charlie.username}"})
    team.save

    get "/teams/#{team.slug}", {}, login(bob)

    assert_response_status(302)

    put "/teams/#{team.slug}/confirm", {}, login(bob)
    get "/teams/#{team.slug}", {}, login(bob)

    assert_response_status(200)
  end

  def test_view_team_as_a_non_member
    team = Team.by(alice).defined_with({slug: 'members', usernames: "#{bob.username}"})
    team.save

    get "/teams/#{team.slug}", {}, login(charlie)

    assert_response_status(302)
  end

  def test_delete_team_without_being_creator
    team = Team.by(alice).defined_with({slug: 'delete', usernames: "#{bob.username}"})
    team.save

    delete "/teams/#{team.slug}", {}, login(bob)

    assert_response_status(302)
    assert Team.exists?(slug: 'delete')
  end

  def test_delete_team_as_creator
    team = Team.by(alice).defined_with({slug: 'delete', usernames: "#{bob.username}"})
    team.save

    delete "/teams/#{team.slug}", {}, login(alice)

    assert_response_status(302)
    refute Team.exists?(slug: 'delete')
  end

  def test_edit_teams_name_and_slug
    team = Team.by(alice).defined_with({slug: 'edit', usernames: "#{bob.username}"})
    team.save

    put "/teams/#{team.slug}", {team: {name: 'New name', slug: 'new_slug'}}, login(alice)

    assert_response_status(302)
    assert team.reload.name == 'New name'
  end

  def test_notify_unconfirmed_members_of_invitation
    TeamInvitationMessage.stub(:ship, nil) do
      post '/teams', {team: {slug: 'abc', usernames: bob.username}}, login(alice)

      assert_equal 0, alice.reload.alerts.count, "Shouldn't notify creator"
      assert_equal 1, bob.reload.alerts.count, "Notify bob failed"

      post "/teams/abc/members", {usernames: charlie.username}, login(alice)

      assert_equal 1, bob.reload.alerts.count, "Bob should not have gotten notified again."
      assert_equal 1, charlie.reload.alerts.count, "Notify charlie failed"
    end
  end
end
