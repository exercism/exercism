require_relative '../acceptance_helper'

class TeamAcceptanceTest < AcceptanceTestCase
  def test_joining_a_team
    creating_user = create_user(username: 'creating_user')
    joining_user = create_user(username: 'joining_user', github_id: 123)

    attributes = { slug: 'some-team', name: 'Some Name', usernames: 'joining_user' }
    Team.by(creating_user).defined_with(attributes, creating_user).save!

    with_login(joining_user) do
      click_on 'Account'

      assert_content 'Some Name'

      click_on 'Accept'

      assert_content 'Some Name'
      assert_content 'joining_user'
    end
  end

  def test_managing_a_team_as_sole_manager
    user = create_user(username: 'foobar', github_id: 123)

    attributes = { slug: 'some-team', name: 'Some Team' }
    Team.by(user).defined_with(attributes, user).save!

    with_login(user) do
      click_on 'Account'

      click_on 'Some Team'
      click_on 'Manage'

      within('#managers') do
        assert_content 'foobar'
        assert_selector 'button.manager_delete.disabled'
      end
    end
  end

  def test_team_pagination

    100.times do |index|
      User.create(username: "foobar_#{index}", github_id: index)
    end

    user = User.first

    attributes = { slug: 'some-team', name: 'Some Team' }
    Team.by(user).defined_with(attributes, user).save!

    with_login(user) do
      visit("http://localhost:4567/teams/slate/streams")
      require 'pry'; binding.pry
      click_link("2")
    end
  end

  #pagination_menu_item.total
end

