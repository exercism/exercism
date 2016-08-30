require_relative '../acceptance_helper'

class NitsTest < AcceptanceTestCase
  def setup
    super
    @user = create_user
  end

  def submission
    @submission ||= begin
      Submission.on(Problem.new('ruby', 'one')).tap do |submission|
        submission.update!(user:  @user)
      end
    end
  end

  def test_navigate_to_edit_nit_page
    nit = submission.comments.create(user: @user, body: "Test nit given body")

    with_login(@user) do
      visit "/submissions/#{submission.key}/nits/#{nit.id}/edit"
      assert_content "Edit Comment"
    end
  end
end
