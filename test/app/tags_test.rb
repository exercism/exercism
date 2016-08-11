require_relative '../app_helper'

class TagsTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  attr_reader :bob, :ruby_team, :rust_team

  def setup
    super
    @bob = User.create(username: 'bob', github_id: 2, track_mentor: ['ruby'], email: "bob@example.com")
    @ruby_team = Team.by(@bob).defined_with(slug: 'ruby team', tags: 'ruby')
    @rust_team = Team.by(@bob).defined_with(slug: 'rust team', tags: 'rust')
  end

  def test_tags_search_responds_with_json
    get "/tags", { q: 'ru' }, login(bob)
    assert_equal "application/json", last_response.header['Content-Type']
  end

  def test_tags_search_returns_similar_tags
    get "/tags", { q: 'ru' }, login(bob)

    response = JSON.parse(last_response.body)
    assert_equal 2, response.size
    assert_includes response, 'ruby'
    assert_includes response, 'rust'
  end
end
