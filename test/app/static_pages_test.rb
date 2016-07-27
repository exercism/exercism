require_relative '../app_helper'

class StaticPagesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismWeb::App
  end

  def test_route_version
    get "/version"
    assert_equal 200, last_response.status
    assert_match /\A{.*"build_id".*}\n\z/, last_response.body
  end
end
