require './test/integration_helper'
require 'mocha/setup'

class EditsTeamTest < Minitest::Test
  include DBCleaner

  def setup
    super
    @controller = mock
    @edits = EditsTeam.new(@controller)
  end

  def team
    @team ||= -> {
      alice = User.create(username: "alice")
      Team.create(creator: alice, name: "Old name", slug: "old_slug")
    }.call
  end

  def test_changing_teams_name_and_slug
    @controller.expects(:team_updated)
    @edits.update(team.slug, name: "New name", slug: "new_slug")

    assert_equal "New name", team.reload.name
    assert_equal "new_slug", team.reload.slug
  end

  def test_changing_teams_name_and_slug_with_empty_name
    @controller.expects(:team_updated)
    @edits.update(team.slug, name: "", slug: "new_slug")

    assert_equal "new_slug", team.reload.name
    assert_equal "new_slug", team.reload.slug
  end

  def test_changing_teams_slug_when_slug_empty
    @controller.expects(:team_invalid)
    @edits.update(team.slug, name: "", slug: "")

    assert_equal "Old name", team.reload.name
    assert_equal "old_slug", team.reload.slug
  end
end
