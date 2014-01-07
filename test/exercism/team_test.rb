require './test/integration_helper'

class TeamTest < MiniTest::Unit::TestCase
  include DBCleaner

  attr_reader :alice, :bob
  def setup
    super
    @alice = User.create(username: 'alice')
    @bob = User.create(username: 'bob')
  end

  def test_team_requires_slug
    refute Team.new.valid?
  end

  def test_team_has_unique_slug
    Team.create(slug: 'purple', creator: alice)
    team = Team.new(slug: 'purple', creator: alice)
    refute team.valid?
    team.save
    assert_equal 1, Team.count
  end

  def test_team_has_default_name
    team = Team.by(alice).defined_with(slug: 'I <3 Exercism')
    team.save

    assert_equal 'I <3 Exercism', team.name
    assert_equal 'i-3-exercism', team.slug
  end

  def test_team_has_explicit_name
    team = Team.create(slug: 'harold', name: 'Purple Crayon', creator: alice)
    assert_equal 'Purple Crayon', team.name
    assert_equal 'harold', team.slug
  end

  def test_normalize_slug
    team = Team.create(slug: 'O HAI!', creator: alice)
    assert_equal 'o-hai', team.slug
  end

  def test_has_members
    team = Team.create(slug: 'purple', unconfirmed_members: [alice], creator: bob)

    assert_equal [alice], team.unconfirmed_members
    assert_equal [], team.members
    refute alice.teams.include?(team)

    team.confirm(alice.username)

    assert_equal [], team.unconfirmed_members
    assert_equal [alice], team.members
    assert alice.teams.include?(team)
  end

  def test_has_creator
    team = Team.create(slug: 'purple', creator: alice)
    assert_equal alice, team.creator

    assert alice.teams_created.include?(team)
  end

  def test_team_inclusion
    team = Team.create(slug: 'sparkle', creator: alice, unconfirmed_members: [bob])

    assert team.includes?(alice)
    refute team.includes?(bob)

    team.confirm(bob.username)
    assert team.includes?(bob)
  end

  def test_team_recruit
    charlie = User.create(username: 'charlie')
    john = User.create(username: 'john-lennon')

    team = Team.create(slug: 'blurple', creator: alice)

    team.recruit(bob.username)
    team.recruit("#{john.username},#{charlie.username}")

    refute team.includes?(bob)
    refute team.includes?(charlie)
    refute team.includes?(john)

    team.confirm(bob.username)
    team.confirm(charlie.username)
    team.confirm(john.username)

    assert team.includes?(bob)
    assert team.includes?(charlie)
    assert team.includes?(john)
  end

  def test_team_does_not_recruit_duplicates
    team = Team.create(slug: 'awesome', creator: alice, unconfirmed_members: [bob])
    team.confirm(bob.username)
    assert_equal 1, team.members.size

    team.recruit(bob.username)
    assert_equal 1, team.members.size
  end

  def test_team_member_dismiss
    team = Team.create(slug: 'awesome', creator: alice, unconfirmed_members: [bob])

    team.confirm(bob.username)
    team.dismiss(bob.username)
    team.reload

    refute team.includes?(bob)
    assert_equal 0, team.members.size
    assert User.where(username: bob.username).first
  end

  def test_team_member_dismiss_invalid_member
    team = Team.create(slug: 'awesome', creator: alice, members: [bob])

    team.confirm(bob.username)
    team.dismiss(alice.username)
    team.reload

    assert_equal 1, team.members.size
  end
end

