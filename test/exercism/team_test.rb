require_relative '../integration_helper'

class TeamTest < Minitest::Test
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

  def test_case_insensitive_find_by_slug
    Team.by(alice).defined_with(slug: 'orange').save
    assert_equal 'orange', Team.find_by_slug('ORANGE').slug
  end

  def test_team_has_unique_slug
    team1 = Team.by(alice).defined_with(slug: 'purple')
    team1.save
    assert_equal 1, Team.count
    team2 = Team.by(alice).defined_with(slug: 'purple')
    refute team2.valid?
    team2.save
    assert_equal 1, Team.count
  end

  def test_slug_normalization
    team = Team.by(alice).defined_with(slug: 'the   amazing__A-team!!!^%')
    team.save
    refute team.new_record?
    assert_equal 'the-amazing-a-team', team.slug
  end

  def test_slug_defaults_to_parameterized_version_of_name
    team = Team.by(alice).defined_with(name: "Zombie Showdown")
    team.save

    refute team.new_record?
    assert_equal "Zombie Showdown", team.name
    assert_equal "zombie-showdown", team.slug
  end

  def test_name_defaults_to_nonnormalized_slug
    team = Team.by(alice).defined_with(slug: 'I <3 Exercism')
    team.save

    refute team.new_record?
    assert_equal 'I <3 Exercism', team.name
    assert_equal 'i-3-exercism', team.slug

    team = Team.by(alice).defined_with(slug: 'Jazz ~.~ Hands', name: "")
    team.save

    refute team.new_record?
    assert_equal 'Jazz ~.~ Hands', team.name
    assert_equal 'jazz-hands', team.slug
  end

  def test_team_has_explicit_name
    team = Team.by(alice).defined_with(slug: 'harold', name: 'Purple Crayon')
    team.save
    assert_equal 1, Team.count
    assert_equal 'Purple Crayon', team.name
    assert_equal 'harold', team.slug
  end

  def test_normalize_slug
    team = Team.by(alice).defined_with(slug: 'O HAI!')
    team.save
    assert_equal 1, Team.count
    assert_equal 'o-hai', team.slug
  end

  def test_has_members
    team = Team.by(bob).defined_with(slug: 'purple', usernames: ['alice'])
    team.save

    assert_equal [alice], team.unconfirmed_members
    assert_equal [], team.members
    refute alice.teams.include?(team)

    team.confirm(alice.username)

    assert_equal [], team.unconfirmed_members
    assert_equal [alice], team.members
    assert alice.teams.include?(team)
  end

  def test_team_inclusion
    team = Team.by(alice).defined_with(slug: 'sparkle', usernames: ['bob'])
    team.save

    assert team.includes?(alice)
    refute team.includes?(bob)

    team.confirm(bob.username)
    assert team.includes?(bob)
  end

  def test_team_recruit
    charlie = User.create(username: 'charlie')
    david = User.create(username: 'david')
    inviter = User.create(username: 'inviter')

    team = Team.by(alice).defined_with(slug: 'blurple')
    team.save

    team.recruit(bob.username, inviter)
    team.recruit("#{david.username},#{charlie.username}", inviter)

    refute team.includes?(bob)
    refute team.includes?(charlie)
    refute team.includes?(david)

    team.confirm(bob.username)
    team.confirm(charlie.username)
    team.confirm(david.username)

    assert team.includes?(bob)
    assert team.includes?(charlie)
    assert team.includes?(david)

    team.members.each do |user|
      assert user.inviters.include? inviter
    end
  end

  def test_team_does_not_recruit_duplicates
    inviter = User.create(username: 'inviter')
    team = Team.by(alice).defined_with(slug: 'awesome', usernames: ['bob'])
    team.save
    member_count = team.all_members.count
    team.confirm(bob.username)
    team.recruit(bob.username, inviter)

    assert_equal member_count, team.all_members.count
  end

  def test_team_member_dismiss
    team = Team.by(alice).defined_with(slug: 'awesome', usernames: ['bob'])
    team.save

    team.confirm(bob.username)
    team.dismiss(bob.username)
    team.reload

    refute team.includes?(bob)
    assert_equal 0, team.members.size
    assert User.where(username: bob.username).first
  end

  def test_team_member_dismiss_invalid_member
    team = Team.by(alice).defined_with(slug: 'awesome', usernames: bob.username)
    team.save

    team.confirm(bob.username)
    team.dismiss(alice.username)
    team.reload

    assert_equal 1, team.members.size
  end

  def test_management
    team = Team.by(alice).defined_with(slug: 'the-a-team')
    team.managed_by(bob)
    team.save

    assert_equal [alice.id, bob.id].sort, team.managers.map(&:id).sort

    alice.reload
    assert_equal [team.id], alice.managed_teams.map(&:id)

    bob.reload
    assert_equal [team.id], bob.managed_teams.map(&:id)
  end

  def test_delete_memberships_with_team
    attributes = { slug: 'delete', usernames: "#{bob.username}" }
    team = Team.by(alice).defined_with(attributes, alice)
    team.save

    assert TeamMembership.exists?(team: team, user: bob, inviter: alice), 'TeamMembership was created.'
    team.destroy
    refute TeamMembership.exists?(team: team, user: bob, inviter: alice), 'TeamMembership was deleted.'
  end
end

