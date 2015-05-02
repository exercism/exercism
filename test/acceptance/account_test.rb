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

      assert_equal '/teams/gocowboys', current_path
      assert_content 'Team Go Cowboys'
      assert_content 'one_username'
      assert_content 'two_username'
    end
  end
end
