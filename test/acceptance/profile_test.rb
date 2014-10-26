require_relative '../acceptance_helper'

class ProfileTest < AcceptanceTestCase
  def setup
    super
    @user = create_user
  end

  def test_submission_date
    alice = create_user(username: 'alice', github_id: 4567)
    exer = UserExercise.create(user: alice, language: 'go', slug: 'one', state: 'pending')
    exer.submissions << Submission.create(user: alice)

    formatted_date = exer.created_at.strftime("%m-%d-%Y")
    with_login(@user) do
      visit "/#{alice.username}"

      assert_equal '/alice', current_path
      assert_equal alice.submissions.count, 1
      assert_content formatted_date
    end
  end
end
