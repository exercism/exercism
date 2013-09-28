require './test/app_helper'

class SetupPageTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def visit_setup_page language
    get "/setup/#{language}"
    assert last_response.body.include?(language)
    assert last_response.body.include?("Installation")
    assert last_response.status == 200
  end

  def test_language_setup_pages
    ['Clojure', 'Ruby', 'Python', 'Elixir', 'Haskell', 'JavaScript'].each do |lang|
      visit_setup_page lang
    end
  end

  def test_usupported_language_returns_not_found
    get '/setup/fortran'
    assert last_response.status == 404
  end
end
