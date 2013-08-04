require './test/api_helper'

class DashboardTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  attr_reader :admin
  def setup
    @admin = User.create({
      username: 'the_admin',
      github_id: 0,
      email: "admin@example.com",
      is_admin: true
    })
  end

  def teardown
    Mongoid.reset
  end

  def generate_submission(language, exe)
    user = User.create({
      username: "#{language}_user",
      github_id: language,
      email: "#{language}_coder@example.com",
      current: { language => "bob" }
    })
    attempt = Attempt.new(user, "class Bob\nend", "bob.#{exe}").save
  end

  def generate_nitpick(attempt)
    Nitpick.new(attempt.submission.id, admin, "It is missing `hey`.").save
  end

  def logged_in
    { github_id: admin.github_id }
  end

  def test_root_with_no_submissions
    get '/', {}, 'rack.session' => logged_in
    assert last_response.body.include?("the_admin"), "visible username"
    assert !last_response.body.include?("bob"), "no visible submission"
    assert_equal last_response.status, 200
  end

  def test_root_with_submissions
    generate_submission("ruby", "rb")
    get '/', {}, 'rack.session' => logged_in
    assert last_response.body.include?("the_admin"), "visible username"
    assert last_response.body.include?("bob"), "visible submission"
    assert_equal last_response.status, 200
  end

  def test_root_with_nitted_submissions
    generate_nitpick(generate_submission("ruby", "rb"))
    get '/', {}, 'rack.session' => logged_in
    assert last_response.body.include?("the_admin"), "visible username"
    assert !last_response.body.include?("bob"), "no visible submission"
    assert_equal last_response.status, 200
  end

  def test_language_when_and_nitted_submission_present
    generate_nitpick(generate_submission("clojure", "clj"))
    get '/dashboard/clojure', {}, 'rack.session' => logged_in
    assert last_response.body.include?("the_admin"), "visible username"
    assert last_response.body.include?("bob"), "visible submission"
    assert_equal last_response.status, 200
  end

  def test_language_when_and_submission_present
    generate_submission("clojure", "clj")
    get '/dashboard/clojure', {}, 'rack.session' => logged_in
    assert last_response.body.include?("the_admin"), "visible username"
    assert last_response.body.include?("bob"), "visible submission"
    assert_equal last_response.status, 200
  end

  def test_language_when_and_nitted_submission_present
    generate_nitpick(generate_submission("clojure", "clj"))
    get '/dashboard/clojure', {}, 'rack.session' => logged_in
    assert last_response.body.include?("the_admin"), "visible username"
    assert last_response.body.include?("bob"), "visible submission"
    assert_equal last_response.status, 200
  end
end
