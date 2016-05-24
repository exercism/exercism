require_relative '../integration_helper'

class DailyTest < Minitest::Test
  include DBCleaner

  def fred
    @fred ||= User.create(username: 'fred')
  end

  def sarah
    @sarah ||= User.create(username: 'sarah')
  end

  def test_only_returns_exercises_for_authorized_language_and_slug
    ACL.authorize(fred, Problem.new('ruby', 'bob'))

    ex1 = create_exercise_with_submission(sarah, 'ruby', 'bob')
    Like.create!(submission: ex1.submissions.first, user: sarah)
    Comment.create!(submission: ex1.submissions.first, user: sarah, body: "I hope that when I die, people say about me, 'Boy, that guy sure owed me a lot of money.'")
    create_exercise_with_submission(sarah, 'ruby', 'leap')

    assert_equal [ex1.key], fred.dailies.map(&:key)
  end

  def test_orders_dailies_by_comment_count
    jaclyn = User.create(username: 'jaclyn')
    ACL.authorize(fred, Problem.new('ruby', 'bob'))

    ex1 = create_exercise_with_submission(sarah, 'ruby', 'bob')
    Like.create!(submission: ex1.submissions.first, user: sarah)
    Comment.create!(submission: ex1.submissions.first, user: sarah, body: "I hope that when I die, people say about me, 'Boy, that guy sure owed me a lot of money.'")

    ex2 = create_exercise_with_submission(jaclyn, 'ruby', 'bob')
    Like.create!(submission: ex1.submissions.first, user: sarah)

    assert_equal [ex2.key, ex1.key], fred.dailies.map(&:key)
  end

  def test_does_not_return_archived_exercises
    ACL.authorize(fred, Problem.new('ruby', 'bob'))
    UserExercise.create!(
      user: fred,
      last_iteration_at: 3.days.ago,
      archived: true,
      iteration_count: 1,
      language: 'ruby',
      slug: 'bob',
      submissions: [Submission.create!(user: fred, language: 'ruby', slug: 'bob', created_at: 22.days.ago, version: 1)]
    )
    assert_equal([], Daily.all)
  end

  def test_does_not_return_hello_world_slug
    ACL.authorize(fred, Problem.new('ruby', 'hello-world'))
    UserExercise.create!(
      user: fred,
      last_iteration_at: 3.days.ago,
      archived: true,
      iteration_count: 1,
      language: 'ruby',
      slug: 'hello-world',
      submissions: [Submission.create!(user: fred, language: 'ruby', slug: 'bob', created_at: 22.days.ago, version: 1)]
    )
    assert_equal([], Daily.all)
  end

  def test_does_not_return_exercises_with_activity_over_30_days
    ACL.authorize(fred, Problem.new('ruby', 'bob'))

    create_exercise_with_submission(sarah, 'ruby', 'bob', 31.days.ago)
    ex2 = create_exercise_with_submission(User.create(username: 'jaclyn'), 'ruby', 'bob', 21.days.ago)

    assert_equal [ex2.key], fred.dailies.map(&:key)
  end

  def test_does_not_return_liked_user_exercises
    ACL.authorize(fred, Problem.new('ruby', 'bob'))

    ex1 = create_exercise_with_submission(sarah, 'ruby', 'bob')
    Like.create!(submission: ex1.submissions.first, user: fred)

    assert_equal [], fred.dailies
  end

  def test_does_not_return_commented_user_exercises
    ACL.authorize(fred, Problem.new('ruby', 'bob'))

    ex1 = create_exercise_with_submission(sarah, 'ruby', 'bob')
    Comment.create!(submission: ex1.submissions.first, user: fred, body: "I hope that when I die, people say about me, 'Boy, that guy sure owed me a lot of money.'")

    assert_equal [], fred.dailies
  end

  private

  def create_exercise_with_submission(user, language, slug, last_iteration_at=1.day.ago)
    UserExercise.create!(
      user: user,
      last_iteration_at: last_iteration_at,
      archived: false,
      iteration_count: 1,
      language: language,
      slug: slug,
      submissions: [Submission.create!(user: user, language: language, slug: slug, created_at: 5.days.ago, version: 1)]
    )
  end
end
