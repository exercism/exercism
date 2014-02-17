require './test/api_helper'
require './test/fixtures/fake_curricula'
require 'mocha/setup'

class AssignmentsApiTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI
  end

  attr_reader :alice, :curriculum
  def setup
    super
    @alice = User.create(username: 'alice', github_id: 1)
    @curriculum = Curriculum.new('./test/fixtures')
    @curriculum.add FakeRubyCurriculum.new
    @curriculum.add FakeGoCurriculum.new
    @curriculum.add FakeScalaCurriculum.new
    Exercism.instance_variable_set(:@trails, nil)
    Exercism.instance_variable_set(:@languages, nil)
  end

  def teardown
    super
    Exercism.instance_variable_set(:@trails, nil)
    Exercism.instance_variable_set(:@languages, nil)
  end

  def test_cannot_fetch_exercise_in_nonexistent_language
    Exercism.stub(:curriculum, curriculum) do
      get '/assignments/nosuch/one'
      assert_equal 400, last_response.status
      assert_match /sorry/i, JSON.parse(last_response.body)['error']
    end
  end

  def test_cannot_fetch_nonexistent_exercise
    Exercism.stub(:curriculum, curriculum) do
      get '/assignments/ruby/million'
      assert_equal 400, last_response.status
      assert_match /sorry/i, JSON.parse(last_response.body)['error']
    end
  end

  def test_fetch_exercise
    Exercism.stub(:curriculum, curriculum) do
      get '/assignments/ruby/one'
      assert_equal 200, last_response.status
      options = {format: :json, name: 'fetch_specific_exercise'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_api_delivers_current_and_upcoming_assignments_for_each_track
    Submission.create(user: alice, language: 'go', slug: 'one', code: 'CODE', state: 'done')
    Submission.create(user: alice, language: 'go', slug: 'two', code: 'CODE', state: 'pending')
    Submission.create(user: alice, language: 'ruby', slug: 'one', code: 'CODE', state: 'pending')

    Exercism.stub(:curriculum, curriculum) do

      get '/user/assignments/current', {key: alice.key}

      output = last_response.body
      options = {format: :json, :name => 'api_current_assignment_data'}
      Approvals.verify(output, options)
    end
  end

  def test_api_retrieves_completed_current_and_upcoming_assignments_for_each_track
    Submission.create(user: alice, language: 'go', slug: 'one', code: 'CODE1GO', state: 'done', filename: 'one.go')
    Submission.create(user: alice, language: 'go', slug: 'two', code: 'CODE2GO', state: 'pending', filename: 'two.go')
    Submission.create(user: alice, language: 'ruby', slug: 'one', code: 'CODE1RB', state: 'pending', filename: 'one.rb')
    Submission.create(user: alice, language: 'ruby', slug: 'two', code: 'CODE2RB', state: 'hibernating', filename: 'two.rb')
    Hack::UpdatesUserExercise.new(alice.id, 'go', 'one').update
    Hack::UpdatesUserExercise.new(alice.id, 'go', 'two').update
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'one').update
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'two').update

    Exercism.stub(:curriculum, curriculum) do

      get '/user/assignments/restore', {key: alice.key}

      output = last_response.body
      options = {format: :json, :name => 'api_restore_assignment_data'}
      Approvals.verify(output, options)
    end
  end

  def test_api_retrieves_next_assignments_even_when_there_are_hibernating_submissions
    Submission.create(user: alice, language: 'ruby', slug: 'one', code: 'CODE', state: 'hibernating')
    Submission.create(user: alice, language: 'go', slug: 'one', code: 'CODE', state: 'done')
    Submission.create(user: alice, language: 'go', slug: 'two', code: 'CODE', state: 'pending')

    Exercism.stub(:curriculum, curriculum) do

      get '/user/assignments/current', {key: alice.key}

      output = last_response.body
      options = {format: :json, :name => 'api_current_assignment_data'}
      Approvals.verify(output, options)
    end
  end

  def test_api_complains_if_no_key_is_submitted
    get '/user/assignments/current'
    assert_equal 401, last_response.status
  end

  def test_api_complains_if_no_key_is_submitted_for_completed_assignments
    get '/user/assignments/completed'
    assert_equal 401, last_response.status
  end

  def test_api_accepts_submission_attempt
    Exercism.stub(:curriculum, curriculum) do
      Notify.stub(:everyone, nil) do
        post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'one/code.rb'}.to_json
      end

      submission = Submission.first
      ex = Exercise.new('ruby', 'one')
      assert_equal ex, submission.exercise
      assert_equal 201, last_response.status

      options = {format: :json, :name => 'api_submission_accepted'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_api_accepts_submission_on_completed_exercise
    Exercism.stub(:curriculum, curriculum) do
      Notify.stub(:everyone, nil) do
        post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'one/code.go'}.to_json
      end

      submission = Submission.first
      ex = Exercise.new('go', 'one')
      assert_equal ex, submission.exercise
      assert_equal 201, last_response.status

      options = {format: :json, :name => 'api_submission_accepted_on_completed'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_api_rejects_submission_on_nonexistent_exercise
    Exercism.stub(:curriculum, curriculum) do
      Notify.stub(:everyone, nil) do
        post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'five/code.rb'}.to_json
      end

      assert_equal 400, last_response.status

      options = {format: :json, :name => 'reject_nonexistent_exercise'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_fetch_at_the_end_of_trail
    Exercism.stub(:curriculum, curriculum) do
      bob = User.create(github_id: 2)
      trail = Exercism.curriculum.in('ruby')
      exercise = trail.exercises.last
      Submission.create(user: bob, language: exercise.language, slug: exercise.slug, state: 'done')
      get '/user/assignments/current', {key: bob.key}
      assert_equal 200, last_response.status
    end
  end

  def test_fetch_demo
    Exercism.stub(:curriculum, curriculum) do
      get '/assignments/demo'
      assert_equal 200, last_response.status

      options = {format: :json, :name => 'api_demo'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_completed_sends_back_empty_list_for_new_user
    new_user = User.create(github_id: 2)

    get '/user/assignments/completed', {key: new_user.key}

    assert_equal({"assignments" => {}}, JSON::parse(last_response.body))
  end

  def test_completed_returns_the_names_of_completed_assignments
    Exercism.stub(:curriculum, curriculum) do
      user = User.create(github_id: 2)
      Submission.create(user: user, code: 'CODE', state: 'done', language: 'ruby', slug: 'one')
      Submission.create(user: user, code: 'CODE', state: 'done', language: 'ruby', slug: 'two')
      Submission.create(user: user, code: 'CODE', state: 'done', language: 'python', slug: 'one')

      get '/user/assignments/completed', {key: user.key}

      assert_equal({"assignments" => {"ruby" => ['one', 'two'], 'python' => ['one']}}, JSON::parse(last_response.body))
    end
  end

  def test_peek_is_deprecated
    get '/user/assignments/next'
    assert_equal 410, last_response.status
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

    post '/user/assignments', {key: bob.key, code: 'THE CODE', path: 'bob/code.rb'}.to_json
    assert_equal 201, last_response.status

    [alice, dave].each do |user|
      assert_equal 1, user.reload.notifications.on_submissions.count, "Notify #{user.username} failed"
    end

    [charlie, eve].each do |user|
      assert_equal 0, user.reload.notifications.on_submissions.count, "#{user.username} was notified, but shouldn't have"
    end
  end

  def test_api_rejects_duplicates
    Exercism.stub(:curriculum, curriculum) do
      Attempt.new(alice, 'THE CODE', 'one/code.rb').save
      Notify.stub(:everyone, nil) do
        post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'one/code.rb'}.to_json
      end

      response_error = JSON.parse(last_response.body)['error']

      assert_equal 400, last_response.status
      assert_equal "This attempt is a duplicate of the previous one.", response_error
    end
  end

  def test_unsubmit_success
    Exercism.stub(:curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit)

      delete '/user/assignments', {key: alice.key}
      assert_equal 204, last_response.status
    end
  end

  def test_unsubmit_fails_no_submission
    Exercism.stub(:curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit).raises(Unsubmit::NothingToUnsubmit.new)

      delete '/user/assignments', {key: alice.key}
      assert_equal 404, last_response.status
    end
  end

  def test_unsubmit_fails_with_nits
    Exercism.stub(:curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionHasNits.new)

      delete '/user/assignments', {key: alice.key}
      assert_equal 403, last_response.status
    end
  end

  def test_unsubmit_fails_when_already_done
    Exercism.stub(:curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionDone.new)

      delete '/user/assignments', {key: alice.key}
      assert_equal 403, last_response.status
    end
  end

  def test_unsubmit_fails_too_old
    Exercism.stub(:curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionTooOld.new)

      delete '/user/assignments', {key: alice.key}
      assert_equal 403, last_response.status
    end
  end

  def test_unsubmit_sets_previous_submission_to_pending_if_exists
    Exercism.stub(:curriculum, curriculum) do
      Submission.create(user: @alice, code: 'CODE', state: 'superseded', language: 'ruby', slug: 'one', version: 1)
      Submission.create(user: @alice, code: 'CODE', state: 'pending', language: 'ruby', slug: 'one', version: 2)

      delete '/user/assignments', { key: @alice.key }

      assert_equal 204, last_response.status
      assert_equal 'pending', Submission.where({ version: 1 }).first.state
    end
  end
end
