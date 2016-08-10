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
      User.create(username: "jane_#{index}", github_id: index)
    end

    user = User.first
    user2 = User.second
    all_users = User.all
    usernames = all_users.collect &:username

    attributes = { slug: 'some-team', name: 'Some Team', confirmed: true }

    team = Team.by(user).defined_with(attributes, user)
    team.save!

    all_users.each do |user|
     TeamMembership.create!(team_id: team.id, user_id: user.id, confirmed: true)
    end

    submission = Submission.create(user: user,
                                   language: 'ruby',
                                   slug: 'leap',
                                   solution: { 'leap.rb': 'CODE' })

    UserExercise.create(user: user,
                        submissions: [submission],
                        language: 'fake',
                        slug: 'apple',
                        iteration_count: 1)

    with_login(user) do
      visit("/teams/some-team/streams")
      click_link("2")
    end

  end

  #pagination_menu_item.total
end
