require './test/integration_helper'
require 'sinatra/base'
require 'rack/test'

require 'app'

class ApiTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def test_it_works
    get '/'
    page = "in layout\nyielded content\nin layout again\n"
    assert_equal page, last_response.body
  end

end
