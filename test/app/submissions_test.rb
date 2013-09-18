require './test/api_helper'
require 'mocha/setup'

class SubmissionsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def alice_attributes
    {
      username: 'alice',
      github_id: 1,
      current: {'ruby' => 'word-count', 'javascript' => 'anagram'},
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
    Attempt.new(alice, code, 'word-count/file.rb').save
  end

  attr_reader :alice, :bob
  def setup
    @alice = User.create(alice_attributes)
    @bob = User.create(bob_attributes)
  end

  def assert_response_status(expected_status)
    assert_equal expected_status, last_response.status
  end

  def logged_in_with_alice
    { github_id: alice.github_id }
  end
  alias_method :logged_in, :logged_in_with_alice

  def logged_in_with_bob
    { github_id: bob.github_id }
  end

  def not_logged_in
    { github_id: nil }
  end

  def teardown
    Mongoid.reset
  end

  def test_submission_view_count
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    assert_equal 0, submission.view_count

    get "/submissions/#{submission.id}", {}, {'rack.session' => {github_id: 2}}

    submission = Submission.first
    assert_equal 1, submission.view_count
  end

  def test_submission_view_count_for_guest
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    assert_equal 0, submission.view_count

    get "/submissions/#{submission.id}"

    submission = Submission.first
    assert_equal 0, submission.view_count
  end

  def test_nitpick_assignment
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      post url, {comment: "good"}, {'rack.session' => {github_id: 2}}
    end
    assert_equal 1, submission.reload.comments.count
    assert_equal 1, submission.reload.nits_by_others_count
  end

  def test_nitpick_own_assignment
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first
    assert_equal 1, submission.versions_count

    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      post url, {comment: "good"}, {'rack.session' => {github_id: 1}}
    end
    assert_equal 1, submission.reload.comments.count
    assert_equal 0, submission.reload.nits_by_others_count
    assert_equal 1, submission.versions_count
    assert_equal true, submission.no_version_has_nits?
  end

  def test_input_sanitation
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first
    nit = Comment.new(user: bob, comment: "ok")
    submission.comments << nit
    submission.save

    # sanitizes response
    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      post url, {comment: "<script type=\"text/javascript\">bad();</script>good"}, {'rack.session' => {github_id: 2}}
    end

    nit = submission.reload.comments.last
    assert_equal "bad();good", nit.comment
  end

  def test_guest_nitpicks
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    post "/submissions/#{submission.id}/respond", {comment: "Could be better by ..."}

    assert_response_status(302)
  end

  def test_multiple_versions
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first
    assert_equal 1, submission.versions_count
    assert_equal 0, submission.comments.count
    assert_equal true, submission.no_version_has_nits?
    assert_equal false, submission.this_version_has_nits?

    # not changed by a nit being added
    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      post url, {comment: "good"}, {'rack.session' => {github_id: 2}}
    end
    assert_equal 1, submission.versions_count
    assert_equal true, submission.no_version_has_nits?
    assert_equal false, submission.this_version_has_nits?

    # not changed by nit being added by another user
    nit = Comment.new(user: bob, comment: "ok")
    submission.comments << nit
    submission.save
    assert_equal 1, submission.versions_count
    assert_equal true, submission.no_version_has_nits?
    assert_equal true, submission.this_version_has_nits?

    # is changed by a new submission
    Attempt.new(alice, 'CODE REVISED', 'word-count/file.rb').save
    new_submission = Submission.where(:slug => submission.slug).last
    assert_equal 2, new_submission.versions_count
    assert_equal false, new_submission.no_version_has_nits?
    assert_equal true, new_submission.some_version_has_nits?
  end

  def test_enable_opinions
    submission = generate_attempt.submission

    Message.stub(:ship, nil) do
      post "/submissions/#{submission.id}/opinions/enable", {}, 'rack.session' => logged_in
    end

    assert_equal true, submission.reload.wants_opinions?
  end

  def test_disable_opinions
    submission = generate_attempt.submission
    submission.wants_opinions = true
    submission.save

    Message.stub(:ship, nil) do
      post "/submissions/#{submission.id}/opinions/disable", {}, 'rack.session' => logged_in
    end

    assert_equal false, submission.reload.wants_opinions?
  end

  def test_like_a_submission
    submission = generate_attempt.submission
    Submission.any_instance.expects(:like!).with(bob)
    post "/submissions/#{submission.id}/like", {}, 'rack.session' => logged_in_with_bob
  end

  def test_unlike_a_submission
    submission = generate_attempt.submission
    Submission.any_instance.expects(:unlike!).with(bob)
    post "/submissions/#{submission.id}/unlike", {}, 'rack.session' => logged_in_with_bob
  end

  def test_change_opinions_when_not_logged_in
    submission = generate_attempt.submission
    post "/submissions/#{submission.id}/opinions/enable", {}, 'rack.session' => not_logged_in
    assert_equal 302, last_response.status
    assert_equal false, submission.reload.wants_opinions?
  end

  def test_mute_submission
    submission = generate_attempt.submission

    Message.stub(:ship, nil) do
      post "/submissions/#{submission.id}/mute", {}, 'rack.session' => logged_in
    end

    assert submission.reload.muted_by?(alice)
  end

  def test_unmute_submission
    submission = generate_attempt.submission

    Message.stub(:ship, nil) do
      post "/submissions/#{submission.id}/unmute", {}, 'rack.session' => logged_in
    end

    refute submission.reload.muted_by?(alice)
  end

  def test_unmute_all_on_new_nitpick
    submission = generate_attempt.submission

    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      Submission.any_instance.expects(:unmute_all!)
      post url, {comment: "good"}, {'rack.session' => {github_id: 2}}
    end
  end

  def test_unmute_all_on_enable_opinions
    submission = generate_attempt.submission

    Message.stub(:ship, nil) do
      Submission.any_instance.expects(:unmute_all!)
      post "/submissions/#{submission.id}/opinions/enable", {}, 'rack.session' => logged_in
    end
  end

  def test_must_be_logged_in_to_complete_exercise
    submission = generate_attempt.submission
    post "/submissions/#{submission.id}/done"
    assert_equal 302, last_response.status
    assert_equal 'pending', submission.reload.state
  end

  def test_must_be_submission_owner_to_complete_exercise
    submission = generate_attempt.submission
    post "/submissions/#{submission.id}/done", {}, 'rack.session' => {github_id: 2}
    assert_equal 302, last_response.status
    assert_equal 'pending', submission.reload.state
  end

  def test_complete_exercise
    submission = generate_attempt.submission
    post "/submissions/#{submission.id}/done", {}, 'rack.session' => {github_id: alice.github_id}
    assert_equal 'done', submission.reload.state
  end

  def test_clicking_complete_on_earlier_version_completes_last_exercise
    data = {
      user: alice,
      code: 'code',
      language: 'ruby',
      slug: 'word-count'
    }
    s1 = Submission.create(data.merge(state: 'superseded', at: Time.now - 5))
    s2 = Submission.create(data.merge(state: 'pending', at: Time.now - 2))

    post "/submissions/#{s1.id}/done", {}, 'rack.session' => {github_id: alice.github_id}

    assert_equal 'superseded', s1.reload.state
    assert_equal 'done', s2.reload.state
  end
end
