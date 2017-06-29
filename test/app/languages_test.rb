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

    # we don't need to check _all_ the tracks.
    %w(Animal Fake Fruit).each do |language|
      assert_match language, last_response.body
    end
  end

  # Don't use assert_match in the rest of these tests,
  # since it dumps the entire HTML response, which is unreadable.

  def test_route_repositories
    get '/repositories'
    assert_equal 200, last_response.status
    assert last_response.body.include?('Language Track Repositories'), "Missing header"
  end

  def test_topic_pages_contain_navigation
    ExercismWeb::Routes::Languages::TOPICS.each do |topic|
      get '/languages/fake/%s' % topic
      assert_equal 200, last_response.status, "Failing on page: %s" % topic

      [
        "About the Fake Track",
        "Available Exercises",
        "Installing Fake",
        "Running the Tests",
        "Useful Fake Resources",
        "Getting Help",
        "Contributing to Fake on Exercism",
      ].each do |nav_item|
        assert last_response.body.include?(nav_item), "Missing text: '%s' in %s page" % [nav_item, topic]
      end
    end
  end

  def test_skip_getting_help_topic_for_tracks_without_exercises
    skip "this is not currently the case. TODO (in a separate PR)"
    get '/languages/vehicles/help'
    refute last_response.body.include?("Getting Help")
  end

  def test_redirects_inactive_tracks_to_launch
    get '/languages/shoes'
    assert_equal 302, last_response.status
    assert_equal "http://example.org/languages/shoes/launch", last_response.location
  end

  def test_launch_doc
    get '/languages/vehicles/launch'
    assert last_response.body.include?("Help Us Launch!"), "Launch header is missing"
    assert last_response.body.include?("https://github.com/exercism/xvehicles/issues/1"), "Checklist issue URL is missing"
    assert last_response.body.include?("<h3>Help Us Launch!</h3>"), "Rendering markdown, not HTML"
  end

  def test_redirects_active_tracks_to_about
    get '/languages/fake'
    assert_equal 302, last_response.status
    assert_equal "http://example.org/languages/fake/about", last_response.location
  end

  def test_when_about_doc_is_present
    get '/languages/fake/about'
    {
      "Language Information" => "Trackler content is missing",
      "<p>Language Information</p>" => "Trackler content is markdown, not HTML",
      "Help us explain this better" => "Request for help is missing",
      "<em>Help us explain this better" => "Request for help is markdown, not HTML",
      "https://github.com/exercism/xfake/blob/master/docs/ABOUT.org" => "Filename is wrong",
      "https://github.com/exercism/xfake/issues" => "Issue URL is wrong",
      "Try It!" => "Call to action is missing",
      "<h3>Try It!</h3>" => "Call to action is markdown, not HTML",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_about_doc_is_missing
    get '/languages/vehicles/about'
    {
      "We're missing a short introduction about the language." => "Fallback content is missing",
      "<p>We're missing a short introduction about the language." => "Fallback content is markdown, not HTML",
      "Try It!" => "Call to action is missing",
      "<h3>Try It!</h3>" => "Call to action is markdown, not HTML",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_there_are_no_exercises
    skip "the page doesn't handle this use case, but should (in a different PR)"
    get '/languages/vehicles/exercises'
    # hard coded HTML, no need to check for markdown.
    text = "There are no available exercises in Transportation Services."
    assert last_response.body.include?(text), "Placeholder text is missing"
  end

  def test_with_exercises
    get '/languages/fake/exercises'
    text = "exercism fetch fake"
    {
      "exercism fetch fake" => "Exercise content is missing",
      "<code>exercism fetch fake</code>" => "Exercise is markdown, not HTML",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_installation_doc_present
    get '/languages/fake/installation'
    {
      "/api/v1/tracks/fake/images/docs/img/test.jpg" => "Trackler content with rewritten URL is missing",
      "<img src=\"/api/v1/tracks/fake/images/docs/img/test.jpg\"></p>" => "Trackler content is markdown, not HTML",
      "Help us explain this better" => "Request for help is missing",
      "<em>Help us explain this better" => "Request for help is markdown, not HTML",
      "https://github.com/exercism/xfake/issues" => "Issue URL is wrong",
      "https://github.com/exercism/xfake/blob/master/docs/INSTALLATION.org" => "Filename is wrong",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_installation_doc_is_missing
    get '/languages/vehicles/installation'
    text = "We're missing the documentation about how to install the language"
    error_message = "Fallback content is missing"
    assert last_response.body.include?(text), error_message
  end

  def test_when_tests_doc_present
    get '/languages/fake/tests'
    {
      "http://example.org/abc/docs/img/test.jpg" => "Trackler content is missing",
      "http://example.org/abc/docs/img/test.jpg\"></p>" => "Trackler content is markdown, not HTML",
      "Help us explain this better" => "Request for help is missing",
      "<em>Help us explain this better" => "Request for help is markdown, not HTML",
      "https://github.com/exercism/xfake/issues" => "Issue URL is wrong",
      # Note. The real file name is actually TESTS.md, because the fixture has a mix of
      # md and org files. This is on purpose, as we're working on handling this
      # in Trackler, but the fix isn't in master yet.
      # Once it lands, we'll need to fix this test test.
      "https://github.com/exercism/xfake/blob/master/docs/TESTS.org" => "Filename is wrong",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_tests_doc_is_missing
    get '/languages/vehicles/tests'
    {
      "We're missing the documentation about how to run the tests." => "Fallback content is missing",
      "<p>We're missing the documentation about how to run the tests." => "Fallback content is markdown, not HTML"
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_learning_doc_present
    get '/languages/fake/learning'
    {
      "Learning Fake!" => "Trackler content is missing",
      "<p>Learning Fake!</p>" => "Trackler content is markdown, not HTML",
      "Help us explain this better" => "Request for help is missing",
      "<em>Help us explain this better" => "Request for help is markdown, not HTML",
      "https://github.com/exercism/xfake/issues" => "Issue URL is wrong",
      "https://github.com/exercism/xfake/blob/master/docs/LEARNING.org" => "Filename is wrong",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_learning_doc_is_missing
    get '/languages/vehicles/learning'
    {
      "We don't have any good resources for learning this from scratch." => "Fallback content is missing",
      "<p>We don't have any good resources for learning this from scratch." => "Fallback content is markdown, not HTML",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_resources_doc_present
    skip "Need to move the RESOURCES with unknown extention to a different fixture and fix the one in Fake."
    get '/languages/fake/resources'
    {
      "Fake resources for fake." => "Trackler content is missing",
      "<p>Fake resources for fake.</p>" => "Trackler content is markdown, not HTML",
      "Help us explain this better" => "Request for help is missing",
      "<em>Help us explain this better" => "Request for help is markdown, not HTML",
      "https://github.com/exercism/xfake/issues" => "Issue URL is wrong",
      "https://github.com/exercism/xfake/blob/master/docs/RESOURCES.md" => "Filename is wrong",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_when_resources_doc_is_missing
    get '/languages/vehicles/resources'
    {
      "We don't have any suggestions for resources that might be helpful." => "Fallback content is missing",
      "<p>We don't have any suggestions for resources that might be helpful.</p>" => "Fallback content is markdown, not HTML",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_help_topic
    get '/languages/vehicles/help'
    {
      "If you're having trouble" => "Content is missing",
      "<a href=\"https://gitter.im/exercism/support\">jump in the support chat</a>" => "Content is markdown, not HTML",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_contribute_topic_on
    get '/languages/fake/contribute'
    {
      "Help Us Improve the Fake Track!" => "Content is missing",
      "<h5>Help Us Improve the Fake Track!</h5>" => "Content is markdown, not HTML",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_todo
    get '/languages/fake/todo'
    {
      "Add new exercises to Fake" => "Content is missing",
      "<h3>Add new exercises to Fake</h3>" => "Content is markdown, not HTML",
    }.each do |text, error_message|
      assert last_response.body.include?(text), error_message
    end
  end

  def test_error_with_existing_track_with_invalid_topic
    get '/languages/animal/invalid-topic'
    assert_equal 404, last_response.status
    assert_match "We don't know anything about", last_response.body
  end

  def test_error_with_non_existant_track_and_valid_topic
    get '/languages/invalid_track/about'
    assert_equal 404, last_response.status
    assert_match "It doesn't look like we have <b>invalid_track</b> yet", last_response.body
  end

  def test_route_invalid_language_invalid_topic
    get '/languages/invalid_track/invalid_topic'
    assert_equal 404, last_response.status
    assert_match 'It doesn\'t look like we have <b>invalid_track</b> yet.', last_response.body
  end
end
