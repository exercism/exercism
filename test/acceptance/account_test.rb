require_relative '../acceptance_helper'

class AccountTest < AcceptanceTestCase
  def setup
    super
    @user = create_user

    # fake load all the languages
    f= './test/fixtures/xapi_v3_tracks.json'
    X::Xapi.stub(:get, [200, File.read(f)]) do
      ExercismWeb::Presenters::Languages.all
    end
    Language.instance_variable_set(:"@by_track_id", {'ruby' => 'Ruby'})
  end

  def teardown
    super
    ExercismWeb::Presenters::Languages.instance_variable_set(:"@all", nil)
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  def test_account_page_exists
    with_login(@user) do
      click_on 'Account'

      assert_css 'h1', text: 'Account'
      assert_content 'Settings'
    end
  end

  # rubocop:disable Metrics/MethodLength
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
      assert_content 'one_username'
      assert_content 'two_username'
    end
  end
  # rubocop:enable Metrics/MethodLength
end
