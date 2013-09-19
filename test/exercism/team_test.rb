require './test/integration_helper'

class TeamTest < Minitest::Test
  def teardown
    Mongoid.reset
  end

  def test_team_has_unique_slug
    Team.create(slug: 'purple')
    team = Team.new(slug: 'purple')
    refute team.valid?
    team.save
    assert_equal 1, Team.count
  end

  def test_has_members
    alice = User.create(username: 'alice')
    team = Team.create(slug: 'purple', members: [alice])

    assert_equal [alice], team.members

    assert alice.teams.include?(team)
  end

  def test_has_creator
    alice = User.create(username: "alice")
    team = Team.create(slug: 'purple', creator: alice)
    assert_equal alice, team.creator

    assert alice.teams_created.include?(team)
  end
end

