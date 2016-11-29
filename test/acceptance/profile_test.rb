require_relative '../acceptance_helper'
require_relative '../active_record_helper'

class ProfileTest < AcceptanceTestCase
  def setup
    super
    @user = create_user
  end

  def test_profile_page_exists
    with_login(@user) do
      click_on 'Profile'

      assert_content "GitHub Profile: #{@user.username}"
      refute_content "Progress:"
    end
  end

  def test_profile_shows_progress
    UserExercise.create(user: @user, language: 'Fake', iteration_count: 1)
    with_login(@user) do
      visit '/'
      click_on 'Profile'

      assert_content "Progress:"
      assert_content 'Fake: 1/4 (25%)'
    end
  end

  def test_display_team_invites_only_in_users_own_profile
    new_user = create_user(username: 'new_user', github_id: 456)
    attributes = { slug: 'some-team', name: 'Some Name', usernames: 'new_user' }
    Team.by(@user).defined_with(attributes, @user).save!

    with_login(@user) do
      visit "/#{new_user.username}"
      refute_content 'Some Name'
    end

    with_login(new_user) do
      visit "/#{new_user.username}"
      assert_content 'Some Name'
    end
  end
end
