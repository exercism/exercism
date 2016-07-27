require_relative '../app_helper'

class StyleGuidePageTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismWeb::App
  end

  def test_styleguide
    get '/styleguide'
    assert_match 'Styleguide', last_response.body
  end
end
