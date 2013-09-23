require './test/test_helper'
require 'exercism/locksmith'
require 'exercism/problem_set'
require 'exercism/team'
require 'exercism/user'
require 'exercism/null_submission'
require 'exercism/exercise'
require 'exercism/locale'
require 'exercism/trail'
require 'exercism/comment'
require 'exercism/submission'
require 'exercism/notification'

class UserTest < Minitest::Test

  def test_identical_users_are_identical
    attributes = {
      username: 'alice',
      current: {'nong' => 'one'},
    }
    user1 = User.new(attributes)
    user2 = User.new(attributes)
    assert_equal user1, user2
  end

  def test_user_create_key
    user = User.create
    assert_match %r{\A[a-z0-9]{40}\z}, user.key
  end

  def test_user_has_a_problem_set
    user = User.new(current: {'nong' => 'one'})
    ex = Exercise.new('nong', 'one')
    assert_equal [ex], user.current_exercises
  end

  def test_user_is_nitpicker_on_completed_assignment
    user = User.new(current: {'nong' => 'two'}, completed: {'nong' => ['one']})
    one = Exercise.new('nong', 'one')
    assert user.nitpicker_on?(one)
  end

  def test_user_is_not_nitpicker_on_current_assignment
    user = User.new(current: {'nong' => 'one'})
    one = Exercise.new('nong', 'one')
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

  def test_user_ongoing_without_submission
    user = User.new(current: {'nong' => 'one'})
    assert_equal [], user.ongoing
  end

  def test_user_ongoing_with_submissions
    user = User.create(current: {'nong' => 'one'})
    exercise = Exercise.new('nong', 'one')

    user.submissions << create_submission(exercise, :code => "s1", state: 'superseded')
    user.submissions << create_submission(exercise, :code => "s2")
    user.save
    user.reload

    assert_equal ["s2"], user.ongoing.map(&:code)
  end

  def test_user_none_done_without_exercises
    user = User.new
    assert_equal [], user.done
  end

  def test_user_done_without_submissions
    user = User.create(current: {'nong' => 'one'})
    assert_equal [], user.done
  end

  def test_user_done_with_submissions
    skip "I have no idea what this test is testing :)"
    user = User.create(current: {'nong' => 'one'}, completed: {'nong' => ['one']})
    exercise = Exercise.new('nong', 'one')

    user.submissions << create_submission(exercise, :code => "s1")
    user.submissions << create_submission(exercise, :code => "s2")
    user.save
    user.reload

    assert_equal ["s2"], user.done.map(&:code)
  end

  def test_user_do!
    user = User.new
    exercise = Exercise.new('nong', 'one')

    user.do!(exercise)
    assert_equal({'nong' => 'one'}, user.reload.current)
  end

  def test_user_is_not_locksmith_by_default
    refute User.new.locksmith?
  end

  def test_find_user_by_case_insensitive_username
    skip "Code needs rewriting to use regexp"
    User.create username: 'alice'
    assert_equal 'alice', User.find_by_username('ALICE').username
  end

  def test_find_a_bunch_of_users_by_case_insensitive_username
    skip "This test isn't really testing any functionality. Should it test find_in_usernames?"
    User.create username: 'alice'
    User.create username: 'bob'
    usernames = User.where(username: ['ALICE', 'BOB']).map(&:username).sort
    assert_equal ['alice', 'bob'], usernames
  end

  private

  def create_submission(exercise, attributes={})
    submission = Submission.on(exercise)
    attributes.each { |key, value| submission[key] = value }
    submission
  end

end

