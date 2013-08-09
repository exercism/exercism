require './test/mongo_helper'

require 'exercism/locksmith'
require 'exercism/user'
require 'exercism/null_submission'
require 'exercism/exercise'
require 'exercism/locale'
require 'exercism/trail'
require 'exercism/submission'
require 'exercism/notification'
require 'exercism/nit'

class UserTest < Minitest::Test

  def teardown
    Mongoid.reset
  end

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
    user = User.new
    assert_match %r{\A[a-z0-9]{40}\z}, user.key
  end

  def test_user_on_a_single_trail
    user = User.new(current: {'nong' => 'one'})
    ex = Exercise.new('nong', 'one')
    assert_equal [ex], user.current_exercises
  end

  def test_user_on_multiple_trails
    user = User.new(current: {'nong' => 'one', 'femp' => 'two'})
    ex1 = Exercise.new('nong', 'one')
    ex2 = Exercise.new('femp', 'two')
    assert_equal [ex1, ex2], user.current_exercises
  end

  def test_user_knows_what_they_are_doing
    user = User.new(current: {'nong' => 'one', 'femp' => 'two'})
    assert user.doing?('femp')
  end

  def test_user_knows_what_they_are_not_doing
    user = User.new(current: {'nong' => 'one'})
    assert !user.doing?('femp')
  end

  def test_user_finds_current_exercise_for_a_language
    user = User.new(current: {'nong' => 'one', 'femp' => 'two'})

    assert_equal Exercise.new('femp', 'two'), user.current_on('femp')
  end

  def test_is_working_on_exercise
    one = Exercise.new('nong', 'one')
    two = Exercise.new('nong', 'two')
    user = User.new(current: {'nong' => 'one'})
    assert user.working_on?(one)
    refute user.working_on?(two)
  end

  def test_user_completes_an_exercise
    nong = Locale.new('nong', 'no', 'not')
    trail = Trail.new(nong, %w(one two three), '/tmp')

    user = User.new(current: {'nong' => 'two'})

    one = Exercise.new('nong', 'one')
    two = Exercise.new('nong', 'two')
    user.complete!(two, on: trail)

    assert user.completed?(two), 'Expected to have completed nong:two'
    assert_equal [one], user.current_exercises
  end

  def test_admin_is_nitpicker_on_anything
    admin = User.new(username: 'alice', is_admin: true)
    assert admin.nitpicker_on?(Exercise.new('lang', 'exercise'))
  end

  def test_admin_may_nitpick_stuff
    admin = User.new(username: 'alice', is_admin: true)
    assert admin.may_nitpick?(Exercise.new('lang', 'exercise'))
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

  def test_user_may_nitpick_an_exercise_they_completed
    user = User.new(current: {'nong' => 'one'})
    nong = Locale.new('nong', 'no', 'not')
    trail = Trail.new(nong, ['one', 'two'], '/tmp')

    one = Exercise.new('nong', 'one')
    user.complete!(one, on: trail)
    assert user.may_nitpick?(one)
  end

  def test_user_may_not_nitpick_future_assignments
    user = User.new(current: {'nong' => 'one'})
    nong = Locale.new('nong', 'no', 'not')
    trail = Trail.new(nong, ['one', 'two'], '/tmp')

    two = Exercise.new('nong', 'two')
    refute user.may_nitpick?(two)
  end

  def test_user_may_nitpick_current_assignments
    user = User.new(current: {'nong' => 'one'})
    one = Exercise.new('nong', 'one')
    assert user.may_nitpick?(one)
  end

  def test_user_not_a_guest
    user = User.new
    refute user.guest?
  end

  def test_user_current_languages
    user = User.new(current: {'nong' => 'one', 'femp' => 'two'})
    assert_equal %w(nong femp).sort, user.current_languages.sort
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

  def test_admin_isnt_new
    admin = User.new(is_admin: true)
    refute admin.new?
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

  def test_admin_is_nitpicker
    admin = User.new(is_admin: true)
    assert admin.nitpicker?
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
    assert_equal [false], user.ongoing.map(&:submitted?)
  end

  def test_user_ongoing_with_submissions
    user = User.create(current: {'nong' => 'one'})
    exercise = Exercise.new('nong', 'one')

    user.submissions << create_submission(exercise, :code => "s1")
    user.submissions << create_submission(exercise, :code => "s2")
    user.save

    assert_equal [true], user.ongoing.map(&:submitted?)
    assert_equal ["s2"], user.ongoing.map(&:code)
  end

  def test_user_none_done_without_exercises
    user = User.new
    assert_equal [], user.done
  end

  def test_user_done_without_submissions
    user = User.create(current: {'nong' => 'one'}, completed: {'nong' => ['one']})
    assert_equal [false], user.done.map(&:submitted?)
  end

  def test_user_done_with_submissions
    user = User.create(current: {'nong' => 'one'}, completed: {'nong' => ['one']})
    exercise = Exercise.new('nong', 'one')

    user.submissions << create_submission(exercise, :code => "s1")
    user.submissions << create_submission(exercise, :code => "s2")
    user.save

    assert_equal [true], user.done.map(&:submitted?)
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

  private

  def create_submission(exercise, attributes={})
    submission = Submission.on(exercise)
    attributes.each { |key, value| submission[key] = value }
    submission
  end

end

