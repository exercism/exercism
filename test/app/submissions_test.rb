require './test/api_helper'

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
    Attempt.new(@alice, code, 'path/to/file.rb').save
  end

  attr_reader :alice
  def setup
    @alice = User.create(alice_attributes)
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
    Attempt.new(alice, 'CODE', 'path/to/file.rb').save
    submission = Submission.first

    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      post url, {comment: "good"}, {'rack.session' => {github_id: 2}}
    end
    assert_equal 1, submission.reload.nits.count
    assert_equal 1, submission.reload.nits_by_others_count
  end

  def test_nitpick_own_assignment
    Attempt.new(alice, 'CODE', 'path/to/file.rb').save
    submission = Submission.first
    assert_equal 1, submission.versions_count

    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      post url, {comment: "good"}, {'rack.session' => {github_id: 1}}
    end
    assert_equal 1, submission.reload.nits.count
    assert_equal 0, submission.reload.nits_by_others_count
    assert_equal 1, submission.versions_count
    assert_equal true, submission.no_version_has_nits?
  end

  def test_submit_comment_on_nit
    bob = User.create(github_id: 2)

    Attempt.new(alice, 'CODE', 'path/to/file.rb').save
    submission = Submission.first
    nit = Nit.new(user: bob, comment: "ok")
    submission.nits << nit
    submission.save

    url = "/submissions/#{submission.id}/nits/#{nit.id}/argue"
    post url, {comment: "idk"}, {'rack.session' => {github_id: 2}}

    nit = submission.reload.nits.find_by(id: nit.id)
    text = nit.comments.first.body
    assert_equal 'idk', text
    assert_equal 0, submission.discussions_involving_user_count

    url = "/submissions/#{submission.id}/nits/#{nit.id}/argue"
    post url, {comment: "self portrait"}, {'rack.session' => {github_id: 1}}

    nit = submission.reload.nits.find_by(id: nit.id)
    text = nit.comments.last.body
    assert_equal 'self portrait', text
    assert_equal 1, submission.discussions_involving_user_count
  end

  def test_input_sanitation
    bob = User.create(github_id: 2, mastery: ['ruby'])

    Attempt.new(alice, 'CODE', 'path/to/file.rb').save
    submission = Submission.first
    nit = Nit.new(user: bob, comment: "ok")
    submission.nits << nit
    submission.save

    # sanitizes argument
    url = "/submissions/#{submission.id}/nits/#{nit.id}/argue"
    post url, {comment: "<script type=\"text/javascript\">alert('You have been taken over, puny human.')</script>valid content <a href=\"foo.html\" onclick=\"alert('Now twice as effective')\">here</a>"}, {'rack.session' => {github_id: 1}}

    nit = submission.reload.nits.find_by(id: nit.id)
    text = nit.comments.last.body
    assert_equal "alert('You have been taken over, puny human.')valid content <a href=\"foo.html\">here</a>", text

    # sanitizes response
    url = "/submissions/#{submission.id}/respond"
    Message.stub(:ship, nil) do
      post url, {comment: "<script type=\"text/javascript\">bad();</script>good"}, {'rack.session' => {github_id: 2}}
    end

    nit = submission.reload.nits.last
    assert_equal "bad();good", nit.comment

    # sanitizes approval
    url = "/submissions/#{submission.id}/approve"
    Message.stub(:ship, nil) do
      post url, {comment: "<script type=\"text/javascript\">awful();</script><a href=\"bad.html\" onblur=\"foo();\">good</a>"}, {'rack.session' => {github_id: 2}}
    end
    nit = submission.reload.nits.last
    assert_equal "awful();<a href=\"bad.html\">good</a>", nit.comment
  end

  def test_multiple_versions
    bob = User.create(github_id: 2, email: "bob@example.com", mastery: ['ruby'])
    Attempt.new(alice, 'CODE', 'path/to/file.rb').save
    submission = Submission.first
    assert_equal 1, submission.versions_count
    assert_equal 0, submission.nits.count
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
    nit = Nit.new(user: bob, comment: "ok")
    submission.nits << nit
    submission.save
    assert_equal 1, submission.versions_count
    assert_equal true, submission.no_version_has_nits?
    assert_equal true, submission.this_version_has_nits?

    # is changed by a new submission
    Attempt.new(alice, 'CODE REVISED', 'path/to/file.rb').save
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
end
