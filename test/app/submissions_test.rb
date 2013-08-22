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

  def generate_attempt(code = 'CODE')
    Attempt.new(@alice, code, 'word-count/file.rb').save
  end

  attr_reader :alice
  def setup
    @alice = User.create(alice_attributes)
  end

  def assert_response_status(expected_status)
    assert_equal expected_status, last_response.status
  end

  def logged_in
    { github_id: @alice.github_id }
  end

  def not_logged_in
    { github_id: nil }
  end

  def teardown
    Mongoid.reset
  end

  def test_nitpick_assignment
    bob = User.create(github_id: 2, email: "bob@example.com", mastery: ['ruby'])
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
    bob = User.create(github_id: 2, mastery: ['ruby'])

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

    # sanitizes approval
    url = "/submissions/#{submission.id}/approve"
    Message.stub(:ship, nil) do
      post url, {comment: "<script type=\"text/javascript\">awful();</script><a href=\"bad.html\" onblur=\"foo();\">good</a>"}, {'rack.session' => {github_id: 2}}
    end
    nit = submission.reload.comments.last
    assert_equal "awful();<a href=\"bad.html\">good</a>", nit.comment
  end

  def test_guest_nitpicks
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    post "/submissions/#{submission.id}/respond", {comment: "Could be better by ..."}

    assert_response_status(302)
  end

  def test_guest_approves
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    post "/submissions/#{submission.id}/approve", {comment: "Looks great!"}

    assert_response_status(302)
  end

  def test_multiple_versions
    bob = User.create(github_id: 2, email: "bob@example.com", mastery: ['ruby'])
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
    bob = User.create(github_id: 2, email: "bob@example.com", mastery: ['ruby'])

    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      Submission.any_instance.expects(:unmute_all!)
      post url, {comment: "good"}, {'rack.session' => {github_id: 2}}
    end
  end

  def test_unmute_all_on_approval
    submission = generate_attempt.submission
    bob = User.create(github_id: 2, email: "bob@example.com", mastery: ['ruby'])

    url = "/submissions/#{submission.id}/approve"
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
end
