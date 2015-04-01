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

  def visit_nitstats_page
    visit "/nits/#{@user.username}/stats"
  end

  def visit_nits_given_page
    visit "/nits/#{@user.username}/given"
  end

  def visit_nits_received_page
     visit "/nits/#{@user.username}/received"
  end

  def test_navigation_to_nitstats_page
    with_login(@user) do
      visit "/#{@user.username}"
      click_on "Nit Stats"
      assert_css 'h1', text: "Nit Stats"
    end
  end

  def test_navigation_to_nits_given_page
    with_login(@user) do
      visit_nitstats_page
      click_on "Nits Given"
      assert_css 'h1', text: 'Nits Given'
    end
  end

  def test_navigation_to_nits_received_page
    with_login(@user) do
      visit_nitstats_page
      click_on "Nits Received"
      assert_css 'h1', text: 'Nits Received'
    end
  end

  def test_nits_given
    submission.comments.create(user: @user, body: "Test nit given body")

    with_login(@user) do
      visit_nits_given_page
      assert_content "Test nit given body"
    end
  end

  def test_nits_given_with_no_nits
    with_login(@user) do
      visit_nits_given_page
      assert_content "You haven't given any nitpicks yet"
    end
  end

  def test_nits_received
    someone_else = User.create(username: "nitpicker_username")
    submission.comments.create(user: someone_else, body: "Test nit received body")

    with_login(@user) do
      visit_nits_received_page
      assert_content "Test nit received body"
      assert_content "nitpicker_username"
    end
  end

  def test_nits_received_with_no_nits
    with_login(@user) do
      visit_nits_received_page
      assert_content "You haven't received any nitpicks yet"
    end
  end

  def test_navigate_to_edit_nit_page
    nit = submission.comments.create(user: @user, body: "Test nit given body")

    with_login(@user) do
      visit "/submissions/#{submission.key}/nits/#{nit.id}/edit"
      assert_content "Edit Nitpick"
    end
  end
end
