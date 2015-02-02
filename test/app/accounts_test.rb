require_relative '../app_helper'

class AccountsTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  attr_reader :bob
  def setup
    super
    @bob = User.create({
      username: 'bob',
      github_id: 1,
      email: "bob@example.com"
    })
  end

  def test_account_show_with_guest
    get '/account'

    assert_equal last_response.status, 302
  end

  def test_account_show_with_user
    get '/account', {}, login(bob)

    assert_equal last_response.status, 200
  end

  def test_account_update_with_guest
    put '/account'

    assert_equal last_response.status, 403
    assert_equal 'You must be logged in to edit your account settings', last_response.body
  end

  def test_account_update_with_user
    put '/account', {account: {email: 'test@example.com'}}, login(bob)

    assert_equal last_response.status, 302
  end
end
