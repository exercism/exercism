require_relative '../api_helper'
require 'mocha/setup'

class AssignmentsApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  attr_reader :alice
  def setup
    super
    @alice = User.create(username: 'alice', github_id: 1)
    Exercism.instance_variable_set(:@trails, nil)
  end

  def teardown
    super
    Exercism.instance_variable_set(:@trails, nil)
  end

  def test_api_accepts_submission_attempt
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'ruby/one/code.rb'}.to_json
      end
    end

    submission = Submission.first
    problem = Problem.new('ruby', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = {format: :json, name: 'api_submission_accepted'}
    Approvals.verify(last_response.body, options)
  end

  def test_api_accepts_submission_attempt_with_multi_file_solution
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        solution = {
          'ruby/one/file1.rb' => 'code 1',
          'ruby/one/file2.rb' => 'code 2'
        }
        post '/user/assignments', {key: alice.key, solution: solution}.to_json
      end
    end

    submission = Submission.first
    problem = Problem.new('ruby', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = {format: :json, name: 'api_multifile_submission_accepted'}
    Approvals.verify(last_response.body, options)
  end

  def test_provides_a_useful_error_message_when_key_is_wrong
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: 'no-such-key', code: 'THE CODE', path: 'ruby/one/code.rb'}.to_json
      end
    end
    assert_equal 401, last_response.status
  end

  def test_api_accepts_submission_on_completed_exercise
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'go/one/code.go'}.to_json
      end
    end

    submission = Submission.first
    problem = Problem.new('go', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = {format: :json, name: 'api_submission_accepted_on_completed'}
    Approvals.verify(last_response.body, options)
  end

  def test_notify_team_members_about_submission
    bob = User.create username: 'bob', github_id: -2
    charlie = User.create username: 'charlie', github_id: -3
    dave = User.create username: 'dave', github_id: -4
    eve = User.create username: 'eve', github_id: -5

    Submission.create(language: 'ruby', slug: 'bob', code: 'CODE', user: charlie)
    Submission.create(language: 'ruby', slug: 'bob', code: 'CODE', user: dave, state: 'done')

    team1 = Team.by(alice).defined_with(slug: 'team1', usernames: [bob, charlie])
    team1.save
    team2 = Team.by(alice).defined_with(slug: 'team2', usernames: [bob, dave, eve])
    team2.save

    team1.confirm(bob.username)
    team2.confirm(bob.username)
    team2.confirm(dave.username)
    team2.confirm(eve.username)

    Xapi.stub(:exists?, true) do
      post '/user/assignments', {key: bob.key, code: 'THE CODE', path: 'ruby/bob/code.rb'}.to_json
    end
    assert_equal 201, last_response.status

    [alice, dave].each do |user|
      assert_equal 1, user.reload.notifications.on_submissions.count, "Notify #{user.username} failed"
    end

    [charlie, eve].each do |user|
      assert_equal 0, user.reload.notifications.on_submissions.count, "#{user.username} was notified, but shouldn't have"
    end
  end

  def test_api_rejects_duplicates
    Attempt.new(alice, 'THE CODE', 'ruby/one/code.rb').save
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'ruby/one/code.rb'}.to_json
      end
    end

    response_error = JSON.parse(last_response.body)['error']

    assert_equal 400, last_response.status
    assert_equal "duplicate of previous iteration", response_error
  end

  def test_unsubmit_success
    unsubmit_object = stub()

    Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
    unsubmit_object.expects(:unsubmit)

    delete '/user/assignments', {key: alice.key}
    assert_equal 204, last_response.status
  end

  def test_unsubmit_fails_no_submission
    unsubmit_object = stub()

    Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
    unsubmit_object.expects(:unsubmit).raises(Unsubmit::NothingToUnsubmit.new)

    delete '/user/assignments', {key: alice.key}
    assert_equal 404, last_response.status
  end

  def test_unsubmit_fails_with_nits
    unsubmit_object = stub()

    Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
    unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionHasNits.new)

    delete '/user/assignments', {key: alice.key}
    assert_equal 403, last_response.status
  end

  def test_unsubmit_fails_when_already_done
    unsubmit_object = stub()

    Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
    unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionDone.new)

    delete '/user/assignments', {key: alice.key}
    assert_equal 403, last_response.status
  end

  def test_unsubmit_fails_too_old
    unsubmit_object = stub()

    Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
    unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionTooOld.new)

    delete '/user/assignments', {key: alice.key}
    assert_equal 403, last_response.status
  end

  def test_unsubmit_sets_previous_submission_to_pending_if_exists
    Submission.create(user: @alice, code: 'CODE', state: 'superseded', language: 'ruby', slug: 'one', version: 1)
    Submission.create(user: @alice, code: 'CODE', state: 'pending', language: 'ruby', slug: 'one', version: 2)

    delete '/user/assignments', { key: @alice.key }

    assert_equal 204, last_response.status
    assert_equal 'pending', Submission.where({ version: 1 }).first.state
  end
end
