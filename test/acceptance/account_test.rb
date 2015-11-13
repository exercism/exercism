require_relative '../acceptance_helper'

class AccountTest < AcceptanceTestCase
  def setup
    super
    @user = create_user
  end

  def test_account_page_exists
    with_login(@user) do
      click_on 'Account'

      assert_css 'h1', text: 'Account'
      assert_content 'Exercises'
    end
  end

  def test_creating_a_team
    create_user(username: 'one_username', github_id: 12345)
    create_user(username: 'two_username', github_id: 4567)

    with_login(@user) do
      click_on 'Account'
      click_on 'new team'

      fill_in 'Slug', with: 'gocowboys'
      fill_in 'Name', with: 'Go Cowboys'
      fill_in 'Usernames', with: 'one_username, two_username'

      click_on 'Save'
      click_on 'Manage'

      assert_equal '/teams/gocowboys/manage', current_path
      assert_content 'Team Go Cowboys'
      assert_content 'one_username'
      assert_content 'two_username'
    end
  end

  def test_team_shows_current_exercises
    team = Team.by(@user).defined_with({ slug: 'some-team', name: 'Some Name'})
    team.save!

    membership = TeamMembership.create!(user: @user, team: team)
    membership.confirm!

    UserExercise.create!(
      user: @user,
      last_iteration_at: 5.days.ago,
      archived: false,
      iteration_count: 1,
      language: 'ruby',
      slug: 'leap',
      submissions: [Submission.create!(user: @user, language: 'ruby', slug: 'leap', created_at: 22.days.ago, version: 1)]
    )
    UserExercise.create!(
      user: @user,
      archived: false,
      iteration_count: 0,
      language: 'ruby',
      slug: 'clock',
    )

    with_login(@user) do
      visit "/teams/some-team"

      assert_content 'Leap'
      assert_no_content 'Clock'
    end
  end
end
