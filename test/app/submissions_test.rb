require './test/api_helper'

class ApiTest < Minitest::Test
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

  attr_reader :alice
  def setup
    @alice = User.create(alice_attributes)
  end

  def teardown
    Mongoid.reset
  end

  def test_nitpick_assignment
    bob = User.create(github_id: 2, email: "bob@example.com", is_admin: true)
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

  def test_multiple_versions
    bob = User.create(github_id: 2, email: "bob@example.com", is_admin: true)
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
end
