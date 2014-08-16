require_relative '../app_helper'

class AppExercisesTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def test_unlock_nitpicking
    alice = User.create(username: 'alice', github_id: 1)
    Submission.create(user: alice, language: 'ruby', slug: 'bob')
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'bob').update

    post '/exercises/ruby/bob', {}, login(alice)

    assert alice.reload.nitpicker_on?(Problem.new('ruby', 'bob'))
  end

  def test_unlock_nitpicking_fails_if_no_submissions
    alice = User.create(username: 'alice', github_id: 1)
    post '/exercises/ruby/bob', {}, login(alice)

    refute alice.reload.nitpicker_on?(Problem.new('ruby', 'bob'))
  end
end
