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
      email: "alice@example.com"
    }
  end

  def bob_attributes
    {
      username: 'bob',
      github_id: 2,
      mastery: ['ruby'],
      email: "bob@example.com"
    }
  end

  def generate_attempt(code = 'CODE')
    Attempt.new(alice, Iteration.new('word-count/file.rb' => code)).save
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
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    get "/submissions/#{Submission.first.key}"
    assert_response_status(200)
  end

  def test_submission_view_count
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    assert_equal 0, submission.view_count

    get "/submissions/#{submission.key}", {}, login(bob)

    assert_equal 1, submission.view_count
  end

  def test_submission_view_count_for_guest
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    assert_equal 0, submission.view_count

    get "/submissions/#{submission.key}"

    assert_equal 0, submission.view_count
  end

  def test_nitpick_assignment
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    url = "/submissions/#{submission.key}/nitpick"
    post url, {body: "good"}, login(bob)
    assert_equal 1, submission.reload.comments.count
  end

  def test_nitpicking_assignment_mutes_it_for_the_nitpicker
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    url = "/submissions/#{submission.key}/nitpick"
    post url, {body: "good"}, login(bob)
    assert_equal 1, MutedSubmission.count
    assert submission.reload.muted_by?(bob.reload)
  end

  def test_nitpick_own_assignment
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    url = "/submissions/#{submission.key}/nitpick"
    post url, {body: "good"}, login(alice)
    assert_equal 1, submission.reload.comments.count
  end

  def test_input_sanitation
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first
    nit = Comment.new(user: bob, body: "ok", created_at: DateTime.now - 1.day)
    submission.comments << nit
    submission.save

    # sanitizes response
    url = "/submissions/#{submission.key}/nitpick"
    post url, {body: "<script type=\"text/javascript\">bad();</script>good"}, login(bob)

    nit = submission.reload.comments.last
    expected = "<p>&lt;script type=\"text/javascript\"&gt;bad();&lt;/script&gt;good</p>"
    assert_equal expected, nit.html_body.strip
  end

  def test_guest_nitpicks
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    post "/submissions/#{submission.key}/nitpick", {body: "Could be better by ..."}

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

  def test_mute_submission
    submission = generate_attempt.submission
    post "/submissions/#{submission.key}/mute", {}, login(alice)
    assert submission.reload.muted_by?(alice)
  end

  def test_unmute_submission
    submission = generate_attempt.submission
    post "/submissions/#{submission.key}/unmute", {}, login(alice)
    refute submission.reload.muted_by?(alice)
  end

  def test_unmute_all_on_new_nitpick
    submission = generate_attempt.submission

    url = "/submissions/#{submission.key}/nitpick"
    Submission.any_instance.expects(:unmute_all!)
    post url, {body: "good"}, login(bob)
  end

  def test_edit_comment
    submission = generate_attempt.submission
    comment = Comment.create(user: bob, submission: submission, body: "```ruby\n\t{a: 'a'}\n```")

    post "/submissions/#{submission.key}/nits/#{comment.id}", {body: "OK"}, login(bob)

    assert_equal "OK", comment.reload.body
  end

  def test_delete_comment
    submission = generate_attempt.submission
    assert_equal 0, Comment.count
    assert_equal 0, submission.nit_count

    comment = CreatesComment.create(submission.id, bob, "ohai")
    assert_equal 1, Comment.count
    assert_equal 1, submission.reload.nit_count

    delete "/submissions/#{submission.key}/nits/#{comment.id}", {}, login(bob)
    assert_equal 0, Comment.count
    assert_equal 0, submission.reload.nit_count

    comment = CreatesComment.create(submission.id, submission.user, "ohai")
    assert_equal 1, Comment.count
    assert_equal 0, submission.reload.nit_count
    delete "/submissions/#{submission.key}/nits/#{comment.id}", {}, login(submission.user)
    assert_equal 0, Comment.count
    assert_equal 0, submission.reload.nit_count
  end

  def test_deleting_submission
    data = {
      user: alice,
      language: 'ruby',
      slug: 'word-count',
      solution: {'word-count.rb' => 'code'},
    }

    sub = Submission.create(data.merge(state: 'pending', created_at: Time.now - 10))
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'word-count').update

    delete "/submissions/#{sub.key}", {}, login(alice)
    assert_equal nil, Submission.find_by_key(sub.key)
  end

  def test_cant_delete_submission_user_doesnt_own
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: {'word-count.rb' => 'code'},
    }

    sub = Submission.create(data.merge(state: 'pending', created_at: Time.now - 10))
    delete "/submissions/#{sub.key}", {}, login(alice)
    assert_equal sub, Submission.find_by_key(sub.key)
  end

  def test_delete_submission_decrements_version_number
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: {'word-count.rb' => 'code'},
    }

    _ = Submission.create(data.merge(state: 'pending', created_at: Time.now - 10, version: 1))
    sub2 = Submission.create(data.merge(state: 'pending', created_at: Time.now - 10, version: 2))
    sub3 = Submission.create(data.merge(state: 'apples', created_at: Time.now - 10, version: 3))
    Hack::UpdatesUserExercise.new(bob.id, 'ruby', 'word-count').update

    delete "/submissions/#{sub2.key}", {}, login(bob)
    assert_equal 2, Submission.find_by_key(sub3.key).version
  end

  def test_redirects_to_index_page_after_deleting
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: {'word-count.rb' => 'code'},
    }

    sub = Submission.create(data.merge(state: 'pending', created_at: Time.now - 10))
    Hack::UpdatesUserExercise.new(bob.id, 'ruby', 'word-count').update

    delete "/submissions/#{sub.key}", {}, login(bob)
    assert_equal 302, last_response.status
    assert_equal "http://example.org/", last_response.location
  end

  def test_delete_superseeded_submission_does_not_change_state_of_prior_submission
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: {'word-count.rb' => 'code'},
    }

    sub  = Submission.create(data.merge(state: 'superseeded', created_at: Time.now - 10, version: 1))
    sub2 = Submission.create(data.merge(state: 'superseeded', created_at: Time.now - 9, version: 2))
    _ = Submission.create(data.merge(state: 'pending', created_at: Time.now - 8, version: 3))
    Hack::UpdatesUserExercise.new(bob.id, 'ruby', 'word-count').update

    delete "/submissions/#{sub2.key}", {}, login(bob)
    assert_equal 'superseeded', sub.reload.state
  end

  def test_delete_pending_submission_changes_state_of_prior_submission
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: {'word-count.rb' => 'code'},
    }

    _ = Submission.create(data.merge(state: 'superseeded', created_at: Time.now - 10, version: 1))
    sub2 = Submission.create(data.merge(state: 'superseeded', created_at: Time.now - 9, version: 2))
    sub3 = Submission.create(data.merge(state: 'pending', created_at: Time.now - 8, version: 3))
    Hack::UpdatesUserExercise.new(bob.id, 'ruby', 'word-count').update

    delete "/submissions/#{sub3.key}", {}, login(bob)
    assert_equal 'pending', sub2.reload.state
  end

  def test_dependent_destroy_of_notifications
    data = {
      user: alice,
      language: 'ruby',
      slug: 'word-count',
      solution: {'word-count.rb' => 'code'},
    }

    sub = Submission.create(data.merge(state: 'pending', created_at: Time.now - 10))
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'word-count').update
    note = Notification.create(user_id: alice.id, item_id: sub.id, item_type: sub.class.to_s, creator_id: bob.id)

    delete "/submissions/#{sub.key}", {}, login(alice)
    assert_equal nil, Notification.find_by_id(note.id)
  end

  def test_redirects_to_submission_page_when_comment_like_or_mute_with_get
    data = {
      user: bob,
      language: 'ruby',
      slug: 'word-count',
      solution: {'word-count.rb' => 'code'},
    }

    sub = Submission.create(data.merge(state: 'needs_input', created_at: Time.now - 5))

    %w(nitpick like unlike mute unmute).each do |action|
      get "/submissions/#{sub.key}/#{action}", {}, login(bob)

      assert_response_status(302)
      assert_equal "http://example.org/submissions/#{sub.key}", last_response.location
    end
  end
end
