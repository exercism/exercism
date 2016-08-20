require_relative '../integration_helper'

class UserTest < Minitest::Test
  include DBCleaner

  def test_user_create_key
    user = User.create
    assert_match /\A[a-z0-9]{32}\z/, user.key
  end

  def test_user_not_a_guest
    user = User.new
    refute user.guest?
  end

  def test_create_user_from_github
    user = User.from_github(23, 'alice', 'alice@example.com', 'avatar_url', 'polyglot')
    assert_equal 1, User.count
    assert_equal 23, user.github_id
    assert_equal 'alice', user.username
    assert_equal 'alice@example.com', user.email
    assert_equal 'avatar_url', user.avatar_url
    assert_equal 'polyglot', user.joined_as
  end

  def test_update_username_from_github
    User.create(github_id: 23)
    user = User.from_github(23, 'bob', nil, nil).reload
    assert_equal 'bob', user.username
  end

  def test_does_not_overwrite_email_or_joined_as_if_present
    User.create(github_id: 23, email: 'alice@example.com', joined_as: 'polyglot')
    user = User.from_github(23, nil, 'new@example.com', nil, 'artisan').reload
    assert_equal 'alice@example.com', user.email
    assert_equal 'polyglot', user.joined_as
  end

  def test_sets_avatar_url
    User.create(github_id: 23)
    user = User.from_github(23, nil, nil, 'new?1234').reload
    assert_equal 'new', user.avatar_url
  end

  def test_overwrites_avatar_url_if_present
    User.create(github_id: 23, avatar_url: 'old')
    user = User.from_github(23, nil, nil, 'new?1234').reload
    assert_equal 'new', user.avatar_url
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
    %w(alice bob).each { |name| User.create(username: name) }
    assert_equal 'alice', User.find_by_username('ALICE').username
  end

  def test_find_a_bunch_of_users_by_case_insensitive_username
    %w(alice bob fred).each { |name| User.create(username: name) }
    assert_equal %w(alice bob), User.find_in_usernames(%w(ALICE BOB)).map(&:username)
  end

  def test_create_users_unless_present
    User.create(username: 'alice')
    User.create(username: 'bob')
    assert_equal %w(alice bob charlie), User.find_or_create_in_usernames(%w(alice BOB charlie)).map(&:username).sort
  end

  def test_delete_team_memberships_with_user
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')

    team = Team.by(alice).defined_with({ slug: 'team a', usernames: bob.username }, alice)
    other_team = Team.by(alice).defined_with({ slug: 'team b', usernames: bob.username }, alice)

    team.save
    other_team.save
    TeamMembershipInvite.where(user: bob).first.accept!

    assert TeamMembership.exists?(team: team, user: bob, inviter: alice), 'Confirmed TeamMembership for bob was created.'
    assert TeamMembershipInvite.exists?(team: other_team, user: bob, inviter: alice), 'TeamMembershipInvite for bob was created.'

    bob.destroy

    refute TeamMembership.exists?(team: team, user: bob, inviter: alice), 'Confirmed TeamMembership was deleted.'
    refute TeamMembershipInvite.exists?(team: other_team, user: bob, inviter: alice), 'TeamMembershipInvite was deleted.'
  end

  def test_increment_adds_to_table
    fred = User.create(username: 'fred')
    fred.increment_daily_count
    count = DailyCount.where(user_id: fred.id).first
    assert_equal 1, count.total
  end

  def test_increment_updates_single_record_per_user
    fred = User.create(username: 'fred')
    5.times { fred.increment_daily_count }

    daily_count = DailyCount.where(user_id: fred.id).first
    assert_equal 5, daily_count.total
    assert_equal 1, DailyCount.count
  end

  def test_dailies_will_subtract_daily_count
    fred = User.create(username: 'fred')
    ACL.authorize(fred, Problem.new('ruby', 'bob'))
    %w(billy rich jaclyn maddy sarah).each do |name|
      create_exercise_with_submission(User.create(username: name), 'ruby', 'bob')
    end

    assert_equal 5, fred.dailies.size
    fred.increment_daily_count
    fred.reload
    assert_equal 4, fred.dailies.size
  end

  def test_user_daily_count
    fred = User.create(username: 'fred')

    fred.increment_daily_count
    assert_equal 1, fred.daily_count
  end

  def test_user_daily_count_returns_0_if_no_daily
    fred = User.create(username: 'fred')

    assert_equal 0, fred.daily_count
  end

  def test_user_share_key
    fred = User.create(username: 'fred')
    assert_equal nil, fred.share_key
    fred.set_share_key
    refute_equal nil, fred.share_key
    fred.unset_share_key
    assert_equal nil, fred.share_key
  end

  def test_user_find_by_username_and_share_key
    fred = User.create(username: 'fred')
    assert_equal nil, User.find_by(username: 'fred', share_key: Exercism.uuid)
    fred.set_share_key
    assert_equal 'fred', User.find_by(username: 'fred', share_key: fred.share_key).username
  end

  def test_track_mentor_without_previous_exercises_has_track_access
    bob = User.create(username: 'bob')
    create_exercise_with_submission_and_acl(bob, 'ruby', 'hamming')

    fred = User.create(username: 'fred')
    fred.invite_to_track_mentor('ruby')

    total_ruby_exercises_count = Submission.select('DISTINCT language, slug').where(language: 'ruby').size
    freds_ruby_acls_count = ACL.where(user_id: fred.id, language: 'ruby').count

    assert_equal total_ruby_exercises_count, freds_ruby_acls_count
  end

  def test_track_mentor_with_previous_exercises_has_track_access
    bob = User.create(username: 'bob')
    create_exercise_with_submission_and_acl(bob, 'ruby', 'hamming')

    fred = User.create(username: 'fred')
    create_exercise_with_submission_and_acl(fred, 'ruby', 'etl')

    fred.invite_to_track_mentor('ruby')

    total_ruby_exercises_count = Submission.select('DISTINCT language, slug').where(language: 'ruby').size
    freds_ruby_acls_count = ACL.where(user_id: fred.id, language: 'ruby').count

    assert_equal total_ruby_exercises_count, freds_ruby_acls_count
  end

  private

  def create_exercise_with_submission(user, language, slug)
    UserExercise.create!(
      user: user,
      last_iteration_at: 3.days.ago,
      archived: false,
      iteration_count: 1,
      language: language,
      slug: slug,
      submissions: [Submission.create!(user: user, language: language, slug: slug, created_at: 22.days.ago, version: 1)]
    )
  end

  def create_exercise_with_submission_and_acl(user, language, slug)
    create_exercise_with_submission(user, language, slug)
    ACL.create(user_id: user.id, language: language, slug: slug)
  end

  def create_submission(problem, attributes={})
    submission = Submission.on(problem)
    attributes.each { |key, value| submission[key] = value }
    submission
  end
end
