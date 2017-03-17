require_relative '../test_helper'
require 'mocha/setup'
require 'flipper_app/authorize'

class FlipperApp::AuthorizeTest < Minitest::Test
  def setup
    FlipperApp::Authorize.any_instance.
      stubs(:authorized_github_ids).
      returns([admin_github_id])
  end

  def test_refuse_flipper_management_for_unauthenticated_users
    env = {'rack.session' => {}}
    response = middleware_response(env)
    assert_forbidden(response)
  end

  def test_refuse_flipper_management_for_nil_session
    env = {'rack.session' => nil}
    response = middleware_response(env)
    assert_forbidden(response)
  end

  def test_refuse_flipper_management_for_unauthorized_users
    env = {'rack.session' => {'github_id' => normal_user_github_id}}
    response = middleware_response(env)
    assert_forbidden(response)
  end

  def test_allow_flipper_management_for_authorized_user
    env = {'rack.session' => {'github_id' => admin_github_id}}
    response = middleware_response(env)
    assert_allowed(response)
  end

  def test_allow_flipper_management_in_development_env
    env = {'rack.session' => nil}
    response = force_development_env { middleware_response(env) }
    assert_allowed(response)
  end

  private

  def assert_forbidden(response)
    assert_equal 403, response[0]
  end

  def assert_allowed(response)
    assert_equal 200, response[0]
  end

  def middleware_response(env)
    noop_app = ->(_) { [200, 'text/plain', ['']] }
    FlipperApp::Authorize.new(noop_app).call(env)
  end

  def admin_github_id
    123
  end

  def normal_user_github_id
    admin_github_id + 1
  end

  def force_development_env
    original_env = ENV['RACK_ENV']
    ENV['RACK_ENV'] = 'development'
    yield
  ensure
    ENV['RACK_ENV'] = original_env
  end
end
