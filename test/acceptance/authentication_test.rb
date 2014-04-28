require_relative '../acceptance_helper'

class AuthenticationTest < AcceptanceTestCase
  def test_can_auth_with_github
    user = User.create!(username: 'some_github_username',
                        github_id: 1234)

    with_login(user) do
      assert_content 'some_github_username'
    end
  end
end
