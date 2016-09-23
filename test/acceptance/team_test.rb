require_relative '../acceptance_helper'

class TeamAcceptanceTest < AcceptanceTestCase
  def test_joining_a_team
    creating_user = create_user(username: 'creating_user')
    joining_user = create_user(username: 'joining_user', github_id: 123)

    attributes = { slug: 'some-team', name: 'Some Name', usernames: 'joining_user' }
    Team.by(creating_user).defined_with(attributes, creating_user).save!

    with_login(joining_user) do
      click_on 'Account'

      assert_content 'Some Name'

      click_on 'Accept'

      assert_content 'Some Name'
      assert_content 'joining_user'
    end
  end

  def test_managing_a_team_as_sole_manager
    user = create_user(username: 'foobar', github_id: 123)

    attributes = { slug: 'some-team', name: 'Some Team' }
    Team.by(user).defined_with(attributes, user).save!

    with_login(user) do
      click_on 'Account'
      click_on 'Some Team'
      click_on 'Manage'

      within('#managers') do
        assert_content 'foobar'
        assert_selector 'button.manager_delete.disabled'
      end
    end
  end

  def test_search_for_public_teams
    user = create_user(username: 'foobar', github_id: 123)

    attributes = { slug: 'some-public-team', name: 'Team A', public: true, tags: 'ruby' }
    Team.by(user).defined_with(attributes, user).save!

    attributes = { slug: 'some-private-team', name: 'Team B', public: false, tags: 'ruby' }
    Team.by(user).defined_with(attributes, user).save!

    with_login(user) do
      visit "/teams?q=ruby"

      within('.teams-result-list') do
        assert_content 'Team A'
        assert_content 'Tags: some-public-team, team a, ruby'
        refute_content 'Team B'
      end
    end
  end

  def test_team_pagination
    user = User.create(username: "foobar", github_id: 123)

    attributes = { slug: 'some-team', name: 'Some Team', confirmed: true }
    team = Team.by(user).defined_with(attributes, user)
    team.save!

    TeamMembership.create!(team_id: team.id, user_id: user.id, confirmed: true)

    submission = Submission.create(user: user,
                                   language: 'ruby',
                                   slug: 'leap',
                                   solution: { 'leap.rb': 'CODE' },
                                   created_at: Time.now - 10)

    3.times do |index|
      UserExercise.create(user: user,
                          submissions: [submission],
                          language: 'fake',
                          slug: "apple#{index}",
                          iteration_count: 1,
                          last_activity_at: Time.now - 10,
                          last_iteration_at: Time.now - 10,
                          fetched_at: Time.now - 10,
                          skipped_at: Time.now - 10)
    end

    with_login(user) do
      visit "/teams/some-team/streams?per_page=2"
      click_link '2'
      assert_content 'Apple0 foobar'
    end
  end
end
