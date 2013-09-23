require './test/api_helper'
require 'mocha/setup'

class TeamsTest < Minitest::Test
  include Rack::Test::Methods

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
    @alice = User.create(alice_attributes)
    @bob = User.create(bob_attributes)
    @john = User.create(john_attributes)
  end

  def assert_response_status(expected_status)
    assert_equal expected_status, last_response.status
  end

  def logged_in_with_alice
    { github_id: alice.github_id }
  end
  alias_method :logged_in, :logged_in_with_alice

  def not_logged_in
    { github_id: nil }
  end

  def teardown
    Mongoid.reset
  end

  def test_team_creation_with_no_members
    assert_equal 0, alice.teams_created.size

    post '/teams', {team: {slug: 'no_members', usernames: ""}}, {'rack.session' => logged_in}

    team = Team.first

    assert_equal 1, alice.teams_created.size
    assert_equal alice, team.creator
  end

  def test_team_creation_with_no_slug
    post '/teams', {team: {usernames: bob.username}}, {'rack.session' => logged_in}

    assert_equal 0, alice.teams_created.size
  end

  def test_team_creation_with_multiple_members
    post '/teams', {team: {slug: 'members', usernames: "#{bob.username},#{john.username}"}}, {'rack.session' => logged_in}

    team = Team.first

    bob.reload
    john.reload

    assert_equal 1, bob.teams.size
    assert_equal 1, john.teams.size

    [alice, bob, john].each do |member|
      assert_equal true, team.includes?(member)
    end
  end

  def test_view_a_team_as_a_member
    team = Team.by(alice).defined_with({slug: 'members', usernames: "#{bob.username},#{john.username}"})
    team.save

    get "/teams/#{team.slug}", {}, {'rack.session' => {github_id: bob.github_id}}

    assert_response_status(200)
  end

  def test_view_team_as_a_non_member
    team = Team.by(alice).defined_with({slug: 'members', usernames: "#{bob.username}"})
    team.save

    get "/teams/#{team.slug}", {}, {'rack.session' => {github_id: john.github_id}}

    assert_response_status(302)
  end
end