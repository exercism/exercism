require_relative '../app_helper'

class StaticPagesTest < Minitest::Test
  include Rack::Test::Methods

  BASE_URL = "http://#{Rack::Test::DEFAULT_HOST}".freeze

  def app
    ExercismWeb::App
  end

  def test_route_rikki_minus
    get '/rikki-'
    assert_redirect BASE_URL + '/rikki'
  end

  def test_route_rikki
    get '/rikki'
    assert_equal 200, last_response.status
    assert_match(/Rikki/, last_response.body)
  end

  def test_route_donate
    get '/donate'
    assert_equal 200, last_response.status
    assert_match(/Donate/, last_response.body)
  end

  def test_route_help
    get '/help'
    assert_equal 200, last_response.status
    assert_match(/Help/, last_response.body)
  end

  def test_route_how_it_works
    get '/how-it-works'
    assert_equal 200, last_response.status
    assert_match(/How it Works/, last_response.body)
    assert_equal nil, session[:target_profile]
  end

  def test_route_how_it_works_polyglot
    get '/how-it-works/polyglot'
    assert_redirect BASE_URL + '/how-it-works'
    assert_equal 'polyglot', session[:target_profile]
  end

  def test_route_how_it_works_artisan
    get '/how-it-works/artisan'
    assert_redirect BASE_URL + '/how-it-works'
    assert_equal 'artisan', session[:target_profile]
  end

  def test_route_how_it_works_newbie
    get '/how-it-works/newbie'
    assert_equal 200, last_response.status
    assert_match(/How it Works: For New Developers/, last_response.body)
    assert_equal 'newbie', session[:target_profile]
  end

  def test_route_cli
    get '/cli'
    assert_equal 200, last_response.status
    assert_match(/Command-Line Interface \(CLI\)/, last_response.body)
  end

  def test_route_privacy
    get '/privacy'
    assert_equal 200, last_response.status
    assert_match(/Privacy/, last_response.body)
  end

  def test_route_about
    get '/about'
    assert_equal 200, last_response.status
    assert_match(/About/, last_response.body)
  end

  def test_route_contribute
    get '/contribute'
    assert_equal 200, last_response.status
    assert_match(/Contribute/, last_response.body)
  end

  def test_route_bork
    get '/bork'
    assert_equal 500, last_response.status
    assert_match(/Hi Bugsnag, you&#x27;re awesome!/, last_response.body)
  end

  def test_route_no_such_page
    get '/no-such-page'
    assert_equal 404, last_response.status
    assert_match(/We don't have that!/, last_response.body)
  end

  def test_route_version
    get "/version"
    assert_equal 200, last_response.status
    assert_match(/\A{.*"build_id".*}\n\z/, last_response.body)
  end

  private

  def session
    last_request.env['rack.session']
  end

  def assert_redirect(expected, response=last_response)
    assert_equal 302, response.status
    assert_equal expected, response.location
  end
end
