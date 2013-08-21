require './test/api_helper'
require './test/fixtures/fake_curricula'

class AssignmentsApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  attr_reader :alice, :curriculum
  def setup
    @alice = User.create(username: 'alice', github_id: 1, current: {'ruby' => 'one', 'go' => 'two'}, completed: {'ruby' => ['zero']})
    @curriculum = Curriculum.new('./test/fixtures')
    @curriculum.add FakeCurriculum.new
    @curriculum.add FakeRubyCurriculum.new
    @curriculum.add FakeGoCurriculum.new
    Exercism.instance_variable_set(:@trails, nil)
    Exercism.instance_variable_set(:@languages, nil)
  end

  def teardown
    Mongoid.reset
    Exercism.instance_variable_set(:@trails, nil)
    Exercism.instance_variable_set(:@languages, nil)
  end

  def test_api_returns_current_assignment_data
    Exercism.stub(:current_curriculum, curriculum) do
      get '/api/v1/user/assignments/current', {key: alice.key}

      output = last_response.body
      options = {format: :json, :name => 'api_current_assignment_data'}
      Approvals.verify(output, options)
    end
  end

  def test_api_complains_if_no_key_is_submitted
    get '/api/v1/user/assignments/current'
    assert_equal 401, last_response.status
  end

  def test_api_complains_if_no_key_is_submitted_for_completed_assignments
    get '/api/v1/user/assignments/completed'
    assert_equal 401, last_response.status
  end

  def test_api_complains_if_no_trail_has_been_started
    Exercism.stub(:current_curriculum, curriculum) do
      bob = User.create(username: 'bob', github_id: 2, current: {})
      post '/api/v1/user/assignments', {key: bob.key, code: 'THE CODE', path: 'one/code.rb'}.to_json
      assert_equal 400, last_response.status
      message = JSON.parse(last_response.body)["error"]
      assert_equal "Please start the trail before submitting.", message
    end
  end

  def test_api_accepts_submission_attempt
    Exercism.stub(:current_curriculum, curriculum) do
      Notify.stub(:everyone, nil) do
        post '/api/v1/user/assignments', {key: alice.key, code: 'THE CODE', path: 'one/code.rb'}.to_json
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
    Exercism.stub(:current_curriculum, curriculum) do
      Notify.stub(:everyone, nil) do
        post '/api/v1/user/assignments', {key: alice.key, code: 'THE CODE', path: 'zero/code.rb'}.to_json
      end

      submission = Submission.first
      ex = Exercise.new('ruby', 'zero')
      assert_equal ex, submission.exercise
      assert_equal 201, last_response.status

      options = {format: :json, :name => 'api_submission_accepted_on_completed'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_api_rejects_submission_on_future_exercise
    Exercism.stub(:current_curriculum, curriculum) do
      Notify.stub(:everyone, nil) do
        post '/api/v1/user/assignments', {key: alice.key, code: 'THE CODE', path: 'future/code.rb'}.to_json
      end

      assert_equal 400, last_response.status

      options = {format: :json, :name => 'reject_future_exercises'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_submit_beyond_end_of_trail
    Exercism.stub(:current_curriculum, curriculum) do
      bob = User.create(github_id: 2, current: {'ruby' => 'two'})
      trail = Exercism.current_curriculum.in('ruby')
      bob.complete! trail.exercises.last, on: trail
      get '/api/v1/user/assignments/current', {key: bob.key}
      assert_equal 200, last_response.status
    end
  end

  def test_fetch_demo
    Exercism.stub(:current_curriculum, curriculum) do
      get '/api/v1/assignments/demo'
      assert_equal 200, last_response.status

      options = {format: :json, :name => 'api_demo'}
      Approvals.verify(last_response.body, options)
    end
  end

  def test_completed_sends_back_empty_list_for_new_user
    new_user = User.create(github_id: 2)

    get '/api/v1/user/assignments/completed', {key: new_user.key}

    assert_equal({"assignments" => []}, JSON::parse(last_response.body))
  end

  def test_completed_returns_the_names_of_completed_assignments
    Exercism.stub(:current_curriculum, curriculum) do
      user = User.create(github_id: 2, current: {'ruby' => 'one'})
      trail = curriculum.in('ruby')
      exercises = trail.exercises.each
      user.complete! exercises.next, on: trail
      user.complete! exercises.next, on: trail

      get '/api/v1/user/assignments/completed', {key: user.key}

      assert_equal({"assignments" => ['one', 'two']}, JSON::parse(last_response.body))
    end
  end

  def test_peek_returns_assignments_for_all_trails
    Exercism.stub(:current_curriculum, curriculum) do
      user = User.create(github_id: 2, current: {'ruby' => 'one', 'go' => 'one'})

      get '/api/v1/user/assignments/next', {key: user.key}

      output = last_response.body
      options = {format: :json, name: 'api_peek_on_two_incomplete_trails'}
      Approvals.verify(output, options)
    end
  end

  def test_peek_behind_complete_trail
    Exercism.stub(:current_curriculum, curriculum) do
      user = User.create(github_id: 2, current: {'ruby' => 'congratulations'})

      get '/api/v1/user/assignments/next', {key: user.key}

      assert_equal 404, last_response.status
      assert_equal "No more assignments!", last_response.body
    end
  end

  def test_peek_returns_assignments_for_incomplete_trails
    Exercism.stub(:current_curriculum, curriculum) do
      user = User.create(github_id: 2, current: {'ruby' => 'congratulations', 'go' => 'one'})

      get '/api/v1/user/assignments/next', {key: user.key}

      assert_equal 200, last_response.status

      output = last_response.body
      options = {format: :json, name: 'api_peek_with_complete_trail'}
      Approvals.verify(output, options)
    end
  end

  def test_api_rejects_duplicates
    Exercism.stub(:current_curriculum, curriculum) do
      Attempt.new(alice, 'THE CODE', 'one/code.rb').save
      Notify.stub(:everyone, nil) do
        post '/api/v1/user/assignments', {key: alice.key, code: 'THE CODE', path: 'one/code.rb'}.to_json
      end

      response_error = JSON.parse(last_response.body)['error']

      assert_equal 400, last_response.status
      assert_equal "This attempt is a duplicate of the previous one.", response_error
    end
  end

  def test_unsubmit_success
    Exercism.stub(:current_curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit)

      delete '/api/v1/user/assignments', {key: alice.key}
      assert_equal 204, last_response.status
    end
  end

  def test_unsubmit_fails_no_submission
    Exercism.stub(:current_curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit).raises(Unsubmit::NothingToUnsubmit.new)

      delete '/api/v1/user/assignments', {key: alice.key}
      assert_equal 404, last_response.status
    end
  end

  def test_unsubmit_fails_with_nits
    Exercism.stub(:current_curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionHasNits.new)

      delete '/api/v1/user/assignments', {key: alice.key}
      assert_equal 403, last_response.status
    end
  end

  def test_unsubmit_fails_already_approved
    Exercism.stub(:current_curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionApproved.new)

      delete '/api/v1/user/assignments', {key: alice.key}
      assert_equal 403, last_response.status
    end
  end

  def test_unsubmit_fails_too_old
    Exercism.stub(:current_curriculum, curriculum) do
      unsubmit_object = stub()

      Unsubmit.expects(:new).with(alice).returns(unsubmit_object)
      unsubmit_object.expects(:unsubmit).raises(Unsubmit::SubmissionTooOld.new)

      delete '/api/v1/user/assignments', {key: alice.key}
      assert_equal 403, last_response.status
    end
  end

end
