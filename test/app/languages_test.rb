require_relative '../app_helper'

class LanguagesRoutesTest < Minitest::Test
  include Rack::Test::Methods

  BASE_URL = "http://#{Rack::Test::DEFAULT_HOST}".freeze

  def app
    ExercismWeb::App
  end

  def test_route_languages
    get '/languages'
    assert_equal 200, last_response.status
    assert_match 'Animal', last_response.body
    assert_match 'Fake', last_response.body
    assert_match 'Fancy Stones', last_response.body
    assert_match 'Fruit', last_response.body
    assert_match 'Shoes & Boots', last_response.body
  end

  def test_route_repositories
    get '/repositories'
    assert_equal 200, last_response.status
    assert_match 'Exercism Repositories', last_response.body
    assert_match 'Basic Components', last_response.body
    assert_match 'Exercises', last_response.body
    assert_match 'Interesting Tools', last_response.body
    assert_match 'Language tracks you can contribute to', last_response.body
    assert_match 'In Progress', last_response.body
    assert_match 'Planned', last_response.body
  end

  def test_route_languages_redirects_to_about_page
    get '/languages/animal'
    assert_equal 302, last_response.status
  end

  def test_route_valid_language_with_valid_topic
    get '/languages/animal/about'
    assert_equal 200, last_response.status
    assert_match "About the Animal Track", last_response.body
    assert_match "Available Exercises", last_response.body
    assert_match "Installing Animal", last_response.body
    assert_match "Running the Tests", last_response.body
    assert_match "Learning Animal", last_response.body
    assert_match "Useful Animal Resources", last_response.body
    assert_match "Getting Help", last_response.body
    assert_match "Contributing to Animal on Exercism", last_response.body
  end

  def test_route_valid_language_with_invalid_topic
    get '/languages/animal/invalid-topic'
    assert_equal 404, last_response.status
    assert_match "We don't know anything about", last_response.body
  end

  def test_route_invalid_language_with_valid_topic
    get '/languages/invalid_track/about'
    assert_equal 404, last_response.status
    assert_match "It doesn't look like we have <b>invalid_track</b> yet", last_response.body
  end

  def test_route_invalid_language_invalid_topic
    get '/languages/invalid_track/invalid_topic'
    assert_equal 404, last_response.status
    assert_match 'It doesn\'t look like we have <b>invalid_track</b> yet.', last_response.body
  end

  def test_all_topics_for_valid_language
    ExercismWeb::Routes::Languages::TOPICS.each do |topic|
      get "/languages/animal/#{topic}"
      assert_equal 200, last_response.status
      assert_match "Animal", last_response.body
    end
  end
end
