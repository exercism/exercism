require_relative '../api_helper'

class LooksApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_looks_fail_gracefully_when_not_logged_in
    get '/looks'
    assert_equal 200, last_response.status
  end

  def test_looks_bail_if_user_is_not_found
    get '/looks', {}, {'rack.session' => { 'github_id' => 42 }}
    assert_equal 401, last_response.status
  end

  def test_looks
    alice = User.create(username: 'alice', github_id: 1)
    bob = User.create(username: 'bob', github_id: 2)

    # if this fails seemingly randomly, we'll need to fix the timestamps so they're in good order
    ux1 = UserExercise.create(user: bob, language: 'go', slug: 'one', state: 'pending', key: 'ux-a')
    ux2 = UserExercise.create(user: bob, language: 'go', slug: 'two', state: 'done', key: 'ux-b')
    ux3 = UserExercise.create(user: bob, language: 'ruby', slug: 'one', state: 'hibernating', key: 'ux-c')

    Look.check!(ux1.id, alice.id)
    Look.check!(ux2.id, alice.id)
    Look.check!(ux3.id, alice.id)

    get '/looks', {}, {'rack.session' => { 'github_id' => alice.github_id }}

    options = {format: :json, :name => 'api_looks'}
    Approvals.verify(last_response.body, options)
  end
end
