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

  def test_changing_email
    with_login(@user) do
      click_on 'Account'

      fill_in 'email', with: 'some@email.com'
      click_on 'Update'

      assert_content 'Updated email address.'
      assert_equal 'some@email.com', find('[name=email]').value
    end
  end
end
