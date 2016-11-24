require_relative '../app_helper'
require 'mocha/setup'

class SubmissionsTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def alice_attributes
    {
      username: 'alice',
      github_id: 1,
      email: "alice@example.com",
    }
  end

  def bob_attributes
    {
      username: 'bob',
      github_id: 2,
      track_mentor: ['ruby'],
      email: "bob@example.com",
    }
  end

  def generate_attempt(code='CODE')
    Attempt.new(alice, Iteration.new({ 'word-count/file.rb' => code }, 'ruby', 'word-count')).save
  end

  attr_reader :alice, :bob
  def setup
    super
    @alice = User.create(alice_attributes)
    @bob = User.create(bob_attributes)
  end

  def assert_response_status(expected_status)
    assert_equal expected_status, last_response.status
  end

  def test_guests_can_view_submissions
    Attempt.new(alice, Iteration.new({ 'fake/hello-world/file.rb' => 'CODE' }, 'fake', 'hello-world')).save
    get "/submissions/#{Submission.first.key}"
    assert_response_status(200)
  end

  def test_nitpick_assignment
    Attempt.new(alice, Iteration.new({ 'word-count/file.rb' => 'CODE' }, 'ruby', 'word-count')).save
    submission = Submission.first

    url = "/submissions/#{submission.key}/nitpick"
    post url, { body: "good" }, login(bob)
    assert_equal 1, submission.reload.comments.count
  end

  def test_nitpick_own_assignment
    Attempt.new(alice, Iteration.new({ 'word-count/file.rb' => 'CODE' }, 'ruby', 'word-count')).save
    submission = Submission.first

    url = "/submissions/#{submission.key}/nitpick"
    post url, { body: "good" }, login(alice)
    assert_equal 1, submission.reload.comments.count
  end

  def test_input_sanitation
    Attempt.new(alice, Iteration.new({ 'word-count/file.rb' => 'CODE' }, 'ruby', 'word-count')).save
    submission = Submission.first
    nit = Comment.new(user: bob, body: "ok", created_at: DateTime.now - 1.day)
    submission.comments << nit
    submission.save

    # sanitizes response
    url = "/submissions/#{submission.key}/nitpick"
    post url, { body: "<script type=\"text/javascript\">bad();</script>good" }, login(bob)

    nit = submission.reload.comments.last
    expected = "<span ng-non-bindable><p>&lt;script type=\"text/javascript\"&gt;bad();&lt;/script&gt;good</p>\n</span>"
    assert_equal expected, nit.html_body.strip
  end

  def test_guest_nitpicks
    Attempt.new(alice, Iteration.new({ 'word-count/file.rb' => 'CODE' }, 'ruby', 'word-count')).save
    submission = Submission.first

    post "/submissions/#{submission.key}/nitpick", body: "Could be better by ..."

    assert_response_status(302)
  end

  def test_like_a_submission
    submission = generate_attempt.submission
    Submission.any_instance.expects(:like!).with(bob)
    post "/submissions/#{submission.key}/like", {}, login(bob)
  end

  def test_unlike_a_submission
    submission = generate_attempt.submission
    Submission.any_instance.expects(:unlike!).with(bob)
    post "/submissions/#{submission.key}/unlike", {}, login(bob)
  end

  def test_unlike_removes_unread_likes
    fred = User.create({username: 'fred', github_id: 3, email: "fred@example.com"})
    submission = generate_attempt.submission

    [bob, fred].each do |user|
      post "/submissions/#{submission.key}/like", {}, login(user)
    end

    post "/submissions/#{submission.key}/unlike", {}, login(fred)

    submission.reload

    assert_equal 1, submission.likes.count
    assert_equal 1, submission.notifications.unread.count
    assert_equal bob.id, submission.notifications.unread.first.actor_id
  end

  def test_edit_comment
    submission = generate_attempt.submission
    comment = Comment.create(user: bob, submission: submission, body: "```ruby\n\t{a: 'a'}\n```")

    post "/submissions/#{submission.key}/nits/#{comment.id}", { body: "OK" }, login(bob)

    assert_equal "OK", comment.reload.body
  end

  def test_delete_comment
    submission = generate_attempt.submission
    assert_equal 0, Comment.count

    comment = CreatesComment.create(submission.id, bob, "ohai")
    assert_equal 1, Comment.count

    delete "/submissions/#{submission.key}/nits/#{comment.id}", {}, login(bob)
    assert_equal 0, Comment.count

    comment = CreatesComment.create(submission.id, submission.user, "ohai")
    assert_equal 1, Comment.count
    delete "/submissions/#{submission.key}/nits/#{comment.id}", {}, login(submission.user)
    assert_equal 0, Comment.count
  end

  def test_deleting_submission
    data = {
      user: alice,
      language: 'ruby',
      slug: 'word-count',
      solution: { 'word-count.rb' => 'code' },
    }

    sub = Submission.create(data.merge(created_at: Time.now - 10))
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'word-count').update

    delete "/submissions/#{sub.key}", {}, login(alice)
    assert_equal nil, Submission.find_by_key(sub.key)
  end

  def test_cant_delete_submission_user_doesnt_own
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: { 'word-count.rb' => 'code' },
    }

    sub = Submission.create(data.merge(created_at: Time.now - 10))
    delete "/submissions/#{sub.key}", {}, login(alice)
    assert_equal sub, Submission.find_by_key(sub.key)
  end

  def test_delete_submission_decrements_version_number
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: { 'word-count.rb' => 'code' },
    }

    _ = Submission.create(data.merge(created_at: Time.now - 10, version: 1))
    sub2 = Submission.create(data.merge(created_at: Time.now - 10, version: 2))
    sub3 = Submission.create(data.merge(created_at: Time.now - 10, version: 3))
    Hack::UpdatesUserExercise.new(bob.id, 'ruby', 'word-count').update

    delete "/submissions/#{sub2.key}", {}, login(bob)
    assert_equal 2, Submission.find_by_key(sub3.key).version
  end

  def test_delete_submission_decrements_user_exercise_iterations
    exercise = UserExercise.create(user: bob, iteration_count: 1)
    sub = Submission.create(user: bob, user_exercise: exercise)
    delete "/submissions/#{sub.key}", {}, login(bob)
    assert_equal 0, exercise.reload.iteration_count
  end

  def test_redirects_to_dashboard_after_deleting
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: { 'word-count.rb' => 'code' },
    }

    sub = Submission.create(data.merge(created_at: Time.now - 10))
    Hack::UpdatesUserExercise.new(bob.id, 'ruby', 'word-count').update

    delete "/submissions/#{sub.key}", {}, login(bob)
    assert_equal 302, last_response.status
    assert_equal "http://example.org/dashboard", last_response.location
  end

  def test_dependent_destroy_of_notifications
    data = {
      user: alice,
      language: 'ruby',
      slug: 'word-count',
      solution: { 'word-count.rb' => 'code' },
    }

    sub = Submission.create(data.merge(created_at: Time.now - 10))
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'word-count').update
    note = Notification.create(user_id: alice.id, iteration_id: sub.id, actor_id: bob.id)

    delete "/submissions/#{sub.key}", {}, login(alice)
    assert_equal nil, Notification.find_by_id(note.id)
  end

  def test_redirects_to_submission_page_when_comment_or_like
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: { 'word-count.rb' => 'code' },
    }

    sub = Submission.create(data.merge(created_at: Time.now - 5))

    %w(nitpick like unlike).each do |action|
      get "/submissions/#{sub.key}/#{action}", {}, login(bob)

      assert_response_status(302)
      assert_equal "http://example.org/submissions/#{sub.key}", last_response.location
    end
  end
end
