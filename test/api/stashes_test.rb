require './test/api_helper'

class StashesApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismAPI
  end

  attr_reader :alice
  def setup
    super
    @alice = User.create(username: 'alice', github_id: 1, current: {'ruby' => 'word-count', 'javascript' => 'anagram'})
  end

  def test_api_accepts_stash_submission_and_returns_stash_file
    post '/user/assignments/stash', {key: alice.key, code: 'THE CODE', filename: 'code.rb'}.to_json
    assert_equal 201, last_response.status

    get '/user/assignments/stash', {key: alice.key, filename: 'code.rb'}
    assert_equal 200, last_response.status
    assert_equal({"code" => 'THE CODE', "filename" => "code.rb"}, JSON::parse(last_response.body))
  end

  def test_only_user_may_see_their_own_list_of_stashed_files
    get '/user/assignments/stash'
    assert_equal 401, last_response.status
  end

  def test_only_user_may_stash_an_assignment
    post '/user/assignments/stash', {code: 'THE CODE', filename: 'code.rb'}.to_json
    assert_equal 401, last_response.status
  end

  def test_stashing_and_retrieving_code
    stashed_data = {'code' => 'THE CODE', 'filename' => 'code.rb'}
    post '/user/assignments/stash', {key: alice.key}.merge(stashed_data).to_json
    assert_equal 201, last_response.status

    get '/user/assignments/stash', {key: alice.key, filename: 'code.rb'}
    assert_equal 200, last_response.status
    assert_equal stashed_data, JSON::parse(last_response.body)
  end

  def test_api_returns_stash_list
    stashed_data = {'code' => 'THE CODE', 'filename' => 'code.rb'}
    post '/user/assignments/stash', {key: alice.key}.merge(stashed_data).to_json
    get '/user/assignments/stash/list', key: alice.key
    assert_equal({"list" => ["code.rb"]}, JSON::parse(last_response.body))
    assert_equal 200, last_response.status
  end

  def test_stash_deleted_on_submission_attempt
    Notify.stub(:everyone, nil) do
      stashed_data = {'code' => 'THE CODE', 'filename' => 'code.rb'}
      post '/user/assignments/stash', {key: alice.key}.merge(stashed_data).to_json
      post '/user/assignments', {key: alice.key, code: 'THE CODE', path: 'code.rb'}.to_json
      get '/user/assignments/stash/list', key: alice.key
    end
    assert_equal({"list" => []}, JSON::parse(last_response.body))
  end
end
