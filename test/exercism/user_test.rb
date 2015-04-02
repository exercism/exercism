require_relative '../integration_helper'

class UserTest < Minitest::Test
  include DBCleaner

  def test_user_create_key
    user = User.create
    assert_match %r{\A[a-z0-9]{32}\z}, user.key
  end

  def test_user_is_nitpicker_on_completed_assignment
    user = User.create
    Submission.create(user: user, language: 'ruby', slug: 'one', state: 'done')
    Hack::UpdatesUserExercise.new(user.id, 'ruby', 'one').update
    one = Problem.new('ruby', 'one')
    assert user.nitpicker_on?(one)
  end

  def test_user_is_not_nitpicker_on_current_assignment
    user = User.create
    Submission.create(user: user, language: 'ruby', slug: 'one', state: 'pending')
    one = Problem.new('ruby', 'one')
    refute user.nitpicker_on?(one)
  end

  def test_user_not_a_guest
    user = User.new
    refute user.guest?
  end

  def test_user_is?
    user = User.new(username: 'alice')
    assert user.is?('alice')
    refute user.is?('bob')
  end

  def test_user_without_submissions_is_new
    user = User.new
    assert user.new?
  end

  def test_user_with_submissions_isnt_new
    user = User.new
    def user.submissions; [:some]; end
    refute user.new?
  end

  def test_locksmith_isnt_new
    locksmith = User.new
    def locksmith.locksmith?
      true
    end
    refute locksmith.new?
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

  def test_locksmith_is_nitpicker
    locksmith = User.new
    def locksmith.locksmith?
      true
    end
    assert locksmith.nitpicker?
  end

  def test_user_with_completed_exercises_is_nitpicker
    user = User.new
    def user.completed; [:some]; end
    assert user.nitpicker?
  end

  def test_user_no_ongoing_without_exercises
    user = User.new
    assert_equal [], user.ongoing
  end

  def test_user_ongoing_with_submissions
    user = User.create
    problem = Problem.new('ruby', 'one')

    user.submissions << create_submission(problem, code: "s1", state: 'superseded')
    user.submissions << create_submission(problem, code: "s2")
    user.save
    user.reload

    assert_equal ["s2"], user.ongoing.map(&:code)
  end

  def test_user_ongoing_ordered_by_latest_updated
    user = User.create
    problem = Problem.new('ruby', 'one')

    first = create_submission(problem, code: "s1", updated_at: Date.yesterday)
    second = create_submission(problem, code: "s2", updated_at: Date.today)

    user.submissions << second
    user.submissions << first
    user.save
    user.reload

    assert_equal second, user.ongoing.first
    assert_equal first, user.ongoing.last
  end

  def test_user_is_not_locksmith_by_default
    refute User.new.locksmith?
  end

  def test_find_user_by_case_insensitive_username
    %w{alice bob}.each do |name| User.create username: name end
    assert_equal 'alice', User.find_by_username('ALICE').username
  end

  def test_find_a_bunch_of_users_by_case_insensitive_username
    %w{alice bob fred}.each do |name| User.create username: name end
    assert_equal ['alice', 'bob'], User.find_in_usernames(['ALICE', 'BOB']).map(&:username)
  end

  def test_create_users_unless_present
    User.create username: 'alice'
    assert_equal ['alice', 'bob'], User.find_or_create_in_usernames(['alice', 'bob']).map(&:username).sort
  end

  private

  def create_submission(problem, attributes={})
    submission = Submission.on(problem)
    attributes.each { |key, value| submission[key] = value }
    submission
  end

end

