require './test/api_helper'

class NitpickAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def login(user)
    set_cookie("_exercism_login=#{user.github_id}")
  end

  attr_reader :master
  def setup
    @master = User.create({
      username: 'the_master',
      github_id: 0,
      email: "master@example.com",
      mastery: ['ruby', 'elixir', 'javascript', 'python', 'clojure']
    })
  end

  def teardown
    Mongoid.reset
    clear_cookies
  end

  def generate_submission(language, exe)
    user = User.create({
      username: "#{language}_user",
      github_id: language,
      email: "#{language}_coder@example.com",
      current: { language => "bob" }
    })
    attempt = Attempt.new(user, "class Bob\nend", "bob/bob.#{exe}").save
  end

  def generate_nitpick(attempt)
    CreatesComment.new(attempt.submission.id, master, "It is missing `hey`.").create
  end

  def test_language_when_and_nitted_submission_present
    generate_nitpick(generate_submission("clojure", "clj"))
    login(master)
    get '/nitpick/clojure/no-nits'
    assert last_response.body.include?("the_master"), "visible username"
    assert last_response.body.include?("bob"), "visible submission"
    assert_equal last_response.status, 200
  end

  def test_language_when_and_submission_present
    generate_submission("clojure", "clj")
    login(master)
    get '/nitpick/clojure/no-nits'
    assert last_response.body.include?("the_master"), "visible username"
    assert last_response.body.include?("bob"), "visible submission"
    assert_equal last_response.status, 200
  end

  def test_language_when_and_nitted_submission_present
    generate_nitpick(generate_submission("clojure", "clj"))
    login(master)
    get '/nitpick/clojure/no-nits'
    assert last_response.body.include?("the_master"), "visible username"
    assert last_response.body.include?("bob"), "visible submission"
    assert_equal last_response.status, 200
  end
end
