require './test/integration_helper'

class TeamTest < Minitest::Test
  def test_team_requires_slug
    refute Team.new.valid?
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

  def test_team_inclusion
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    team = Team.create(slug: 'sparkle', creator: alice, members: [bob])

    assert team.includes?(alice)
    assert team.includes?(bob)
  end

  def test_team_recruit
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    charlie = User.create(username: 'charlie')
    john = User.create(username: 'john-lennon')

    team = Team.create(slug: 'blurple', creator: alice)

    team.recruit(bob.username)
    team.recruit("#{john.username},#{charlie.username}")

    assert team.includes?(bob)
    assert team.includes?(charlie)
    assert team.includes?(john)
  end

  def test_team_does_not_recruit_duplicates
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    team = Team.create(slug: 'awesome', creator: alice, members: [bob])
    assert_equal 1, team.members.size

    team.recruit(bob.username)
    assert_equal 1, team.members.size
  end

  def test_team_member_dismiss
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    team = Team.create(slug: 'awesome', creator: alice, members: [bob])

    team.dismiss(bob.username)
    team.reload

    refute team.includes?(bob)
    assert_equal 0, team.members.size
    assert User.where(username: bob.username).first
  end

  def test_team_member_dismiss_invalid_member
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    team = Team.create(slug: 'awesome', creator: alice, members: [bob])

    team.dismiss(alice.username)
    team.reload

    assert_equal 1, team.members.size
  end
end

