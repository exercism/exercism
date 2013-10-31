require './test/app_helper'
require 'mocha/setup'

class TeamsTest < Minitest::Test
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
      current: {'ruby' => 'word-count', 'javascript' => 'anagram'},
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

  def john_attributes
    {
      username: 'john',
      github_id: 3,
      mastery: ['ruby'],
      email: "john@example.com"
    }
  end

  attr_reader :alice, :bob, :john
  def setup
    super
    @alice = User.create(alice_attributes)
    @bob = User.create(bob_attributes)
    @john = User.create(john_attributes)
  end

  def assert_response_status(expected_status)
    assert_equal expected_status, last_response.status
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
    post '/teams', {team: {slug: 'members', usernames: "#{bob.username},#{john.username}"}}, login(alice)

    team = Team.first

    bob.reload
    john.reload

    assert_equal 1, bob.teams.size
    assert_equal 1, john.teams.size

    [alice, bob, john].each do |member|
      assert_equal true, team.includes?(member)
    end
  end

  def test_member_addition
    team = Team.by(alice).defined_with({slug: 'members'})
    team.save

    post "/teams/#{team.slug}/members", {usernames: "#{bob.username},#{john.username}"}, login(alice)

    team.reload

    assert team.includes?(bob)
    assert team.includes?(john)
  end

  def test_member_addition_without_being_creator
    team = Team.by(alice).defined_with({slug: 'members', usernames: bob.username})
    team.save

    post "/teams/#{team.slug}/members", {usernames: john.username}, login(bob)

    team.reload

    assert_response_status(302)
    refute team.includes?(john)
  end

  def test_member_removal
    team = Team.by(alice).defined_with({slug: 'awesome', usernames: "#{bob.username},#{john.username}"})
    team.save

    delete "/teams/#{team.slug}/members/#{bob.username}", {}, login(alice)

    team.reload

    refute team.includes?(bob)
  end

  def test_leave_team
    team = Team.by(alice).defined_with({slug: 'awesome', usernames: "#{bob.username},#{john.username}"})
    team.save

    put "/teams/#{team.slug}/leave", {}, login(bob)

    team.reload

    refute team.includes?(bob)
  end

  def test_member_removal_without_being_creator
    team = Team.by(alice).defined_with({slug: 'members', usernames: "#{bob.username},#{john.username}"})
    team.save

    delete "/teams/#{team.slug}/members/#{john.username}", {}, login(bob)

    team.reload

    assert_response_status(302)
    assert team.includes?(john)
  end

  def test_view_a_team_as_a_member
    team = Team.by(alice).defined_with({slug: 'members', usernames: "#{bob.username},#{john.username}"})
    team.save

    get "/teams/#{team.slug}", {}, login(bob)

    assert_response_status(200)
  end

  def test_view_team_as_a_non_member
    team = Team.by(alice).defined_with({slug: 'members', usernames: "#{bob.username}"})
    team.save

    get "/teams/#{team.slug}", {}, login(john)

    assert_response_status(302)
  end
end
