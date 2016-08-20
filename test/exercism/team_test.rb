require_relative '../integration_helper'

class TeamTest < Minitest::Test
  include DBCleaner

  attr_reader :alice, :bob, :charlie
  def setup
    super
    @alice = User.create(username: 'alice')
    @bob = User.create(username: 'bob')
    @charlie = User.create(username: 'charlie-brown')
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
    team = Team.by(bob).defined_with(slug: 'purple', usernames: '  alice    , charlie-brown ')
    team.save
    team.reload

    assert_equal [alice, charlie], team.member_invites
    assert team.members.empty?
    refute alice.teams.include?(team)

    alice.team_membership_invites_for(team).accept!
    team.reload

    assert_equal [charlie], team.member_invites
    assert_equal [alice], team.members
    assert alice.teams.include?(team)
  end

  def test_team_invite
    inviter = User.create(username: 'inviter')

    team = Team.by(alice).defined_with(slug: 'blurple')
    team.save

    team.invite(bob, inviter)
    team.reload

    refute team.includes?(bob)
    assert team.member_invites.include?(bob)
  end

  def test_team_does_not_invite_more_than_once
    inviter = User.create(username: 'inviter')
    team = Team.by(alice).defined_with(slug: 'awesome', usernames: 'bob')
    team.save
    team.reload

    assert_equal 1, bob.team_membership_invites.where(team_id: team).count
    team.invite(bob, inviter)
    assert_equal 1, bob.team_membership_invites.where(team_id: team).count
  end

  def test_team_member_dismiss
    team = Team.by(alice).defined_with(slug: 'awesome', usernames: 'bob')
    team.save

    bob.team_membership_invites_for(team).accept!
    team.reload
    assert team.includes?(bob)

    team.dismiss(bob.username)
    team.reload
    refute team.includes?(bob)
  end

  def test_team_member_dismiss_ignores_invalid_member
    team = Team.by(alice).defined_with(slug: 'awesome', usernames: bob.username)
    team.save

    bob.team_membership_invites_for(team).accept!
    team.reload
    assert_equal 1, team.members.size

    team.dismiss('invalid-member')
    assert_equal 1, team.members.size
  end

  def test_team_member_dismiss_removes_membership
    team = Team.by(alice).defined_with(slug: 'awesome', usernames: 'bob')
    team.save

    bob.team_membership_invites_for(team).accept!
    assert TeamMembership.exists?(team_id: team, user_id: bob)

    team.dismiss(bob.username)
    refute TeamMembership.exists?(team_id: team, user_id: bob)
  end

  def test_destroy_doesnt_leave_orphan_team_memberships
    attributes = { slug: 'delete', usernames: bob.username.to_s }
    team = Team.by(alice).defined_with(attributes, alice)
    team.save

    bob.team_membership_invites_for(team).accept!

    assert TeamMembership.exists?(team: team, user: bob, inviter: alice)
    team.destroy
    refute TeamMembership.exists?(team: team, user: bob, inviter: alice)
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

  def test_all_tags_converts_tag_ids_into_tag_names
    attributes = { slug: 'team', tags: 'team, tags' }
    team = Team.by(alice).defined_with(attributes, alice)
    team.save

    assert_equal 'team, tags', team.all_tags
  end

  def test_search_public_with_tag
    attributes = { slug: 'public team', tags: 'exercism', public: true }
    public_team = Team.by(alice).defined_with(attributes, alice)
    attributes = { slug: 'private team', tags: 'exercism', public: false }
    private_team = Team.by(alice).defined_with(attributes, alice)

    exercism_tag = Tag.find_by(name: 'exercism')

    public_team.save
    private_team.save

    teams = Team.search_public_with_tag(exercism_tag.id)
    assert_equal 1, teams.size
    assert_equal 'public team', teams.first.name
  end
end
