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
end
