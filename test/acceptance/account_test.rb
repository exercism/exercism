require_relative '../acceptance_helper'

class AccountTest < AcceptanceTestCase
  def setup
    super
    @user = create_user

    Language.instance_variable_set(:"@by_track_id", 'ruby' => 'Ruby')
  end

  def teardown
    super
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  def test_account_page_exists
    with_login(@user) do
      click_on 'Account'

      assert_css 'h1', text: 'Account'
      assert_content 'Settings'
    end
  end

  def test_creating_a_team
    create_user(username: 'one_username', github_id: 12_345)
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
      assert_content 'one_username'
      assert_content 'two_username'
    end
  end
end
