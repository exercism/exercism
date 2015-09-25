require_relative '../integration_helper'

class UserTest < Minitest::Test
  include DBCleaner

  def test_user_create_key
    user = User.create
    assert_match %r{\A[a-z0-9]{32}\z}, user.key
  end

  def test_user_not_a_guest
    user = User.new
    refute user.guest?
  end

  def test_create_user_from_github
    user = User.from_github(23, 'alice', 'alice@example.com', 'avatar_url')
    assert_equal 1, User.count
    assert_equal 23, user.github_id
    assert_equal 'alice', user.username
    assert_equal 'alice@example.com', user.email
    assert_equal 'avatar_url', user.avatar_url
  end

  def test_update_username_from_github
    User.create(github_id: 23)
    user = User.from_github(23, 'bob', nil, nil).reload
    assert_equal 'bob', user.username
  end

  def test_does_not_overwrite_email_if_present
    User.create(github_id: 23, email: 'alice@example.com')
    user = User.from_github(23, nil, 'new@example.com', nil).reload
    assert_equal 'alice@example.com', user.email
  end

  def test_sets_avatar_url_unless_present
    User.create(github_id: 23)
    user = User.from_github(23, nil, nil, 'new?1234').reload
    assert_equal 'new', user.avatar_url
  end

  def test_does_not_overwrite_avatar_url_if_present
    User.create(github_id: 23, avatar_url: 'old')
    user = User.from_github(23, nil, nil, 'new?1234').reload
    assert_equal 'old', user.avatar_url
  end

  def test_from_github_unsets_old_duplicate_username
    u1 = User.create(github_id: 23, username: 'alice')
    u2 = User.from_github(31, 'alice', nil, nil).reload
    assert_equal 'alice', u2.username
    assert_equal '', u1.reload.username

    # it doesn't overwrite it's own username next time
    u3 = User.from_github(31, 'alice', nil, nil).reload
    assert_equal 'alice', u3.username
  end

  def test_from_github_connects_invited_user
    u1 = User.create(username: 'alice')
    u2 = User.from_github(42, 'alice', 'alice@example.com', 'avatar').reload

    u1.reload

    assert_equal u2.id, u1.id
    assert_equal 42, u1.github_id
  end

  def test_find_user_by_case_insensitive_username
    %w{alice bob}.each do |name| User.create(username: name) end
    assert_equal 'alice', User.find_by_username('ALICE').username
  end

  def test_find_a_bunch_of_users_by_case_insensitive_username
    %w{alice bob fred}.each do |name| User.create(username: name) end
    assert_equal ['alice', 'bob'], User.find_in_usernames(['ALICE', 'BOB']).map(&:username)
  end

  def test_create_users_unless_present
    User.create(username: 'alice')
    User.create(username: 'bob')
    assert_equal ['alice', 'bob', 'charlie'], User.find_or_create_in_usernames(['alice', 'BOB', 'charlie']).map(&:username).sort
  end

  def test_delete_team_memberships_with_user
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    team = Team.by(alice).defined_with({ slug: 'team a', usernames: bob.username }, alice)
    other_team = Team.by(alice).defined_with({ slug: 'team b', usernames: bob.username }, alice)

    team.save
    other_team.save
    TeamMembership.where(user: bob).first.confirm!

    assert TeamMembership.exists?(team: team, user: bob, inviter: alice), 'Confirmed TeamMembership for bob was created.'
    assert TeamMembership.exists?(team: other_team, user: bob, inviter: alice), 'Unconfirmed TeamMembership for charlie was created.'

    bob.destroy

    refute TeamMembership.exists?(team: team, user: bob, inviter: alice), 'Confirmed TeamMembership was deleted.'
    refute TeamMembership.exists?(team: other_team, user: bob, inviter: alice), 'Unconfirmed TeamMembership was deleted.'
  end

  def test_increment_adds_to_table
    fred = User.create(username: 'fred')
    fred.increment_five_a_day
    count = FiveADayCount.where(user_id: fred.id).first
    assert_equal 1, count.total
  end

  def test_increment_updates_single_record_per_user
    fred = User.create(username: 'fred')
    5.times {fred.increment_five_a_day}

    count = FiveADayCount.where(user_id: fred.id).first
    assert_equal 5, count.total
    assert_equal 1, FiveADayCount.count
  end

  private

  def create_submission(problem, attributes={})
    submission = Submission.on(problem)
    attributes.each { |key, value| submission[key] = value }
    submission
  end
end
